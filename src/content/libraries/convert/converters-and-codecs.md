---
ia-translate: true
title: Converters e codecs
description: Aprenda como escrever conversões eficientes.
showBreadcrumbs: false
original-date: 2014-02-06
date: 2015-03-17
obsolete: true
---

_Escrito por Florian Loitsch <br>
Fevereiro de 2014 (atualizado em Março de 2015)_

Converter dados entre diferentes representações é uma tarefa comum em
engenharia da computação. Dart não é exceção e vem com
[dart:convert]({{site.dart-api}}/dart-convert/dart-convert-library.html),
uma biblioteca principal que fornece um conjunto
de conversores e ferramentas
úteis para construir novos conversores.
Exemplos de conversores fornecidos pela
biblioteca incluem aqueles para codificações comumente usadas como JSON e UTF-8.
Neste documento, mostramos como os conversores do Dart funcionam e como você
pode criar seus próprios conversores eficientes que se encaixam no mundo Dart.

## Visão geral {:#big-picture}

A arquitetura de conversão do Dart é baseada em _conversores_ (converters), que
traduzem de uma representação para outra. Quando as conversões são reversíveis,
dois conversores são agrupados em um _codec_ (codificador-decodificador). O
termo codec é frequentemente usado para processamento de áudio e vídeo, mas
também se aplica a codificações de string, como UTF-8 ou JSON.


Por convenção, todos os conversores em Dart usam as abstrações fornecidas na
biblioteca dart:convert. Isso fornece uma API consistente para os
desenvolvedores e garante que os conversores possam trabalhar juntos. Por
exemplo, conversores (ou codecs) podem ser fundidos se seus tipos
corresponderem, e o conversor resultante pode ser usado como uma única unidade.
Além disso, esses conversores fundidos geralmente funcionam de forma mais
eficiente do que se tivessem sido usados separadamente.

## Codec {:#codec}

Um codec é uma combinação de dois conversores onde um codifica e o outro
decodifica:

```dart
abstract class Codec<S, T> {
  const Codec();

  T encode(S input) => encoder.convert(input);
  S decode(T encoded) => decoder.convert(encoded);

  Converter<S, T> get encoder;
  Converter<T, S> get decoder;

  Codec<S, dynamic> fuse(Codec<T, dynamic> other) { .. }
  Codec<T, S> get inverted => ...;
}
```

Como pode ser visto, os codecs fornecem métodos de conveniência como `encode()` e
`decode()` que são expressos em termos do encoder e decoder. O método `fuse()`
e o getter `inverted` permitem que você funda conversores e
altere a direção de um codec, respectivamente.
A implementação base de
[Codec]({{site.dart-api}}/dart-convert/Codec-class.html)
para esses dois membros
fornece uma implementação padrão sólida
e os implementadores geralmente não precisam se preocupar com eles.

Os métodos `encode()` e `decode()`, também podem ser deixados
intocados, mas podem ser estendidos para argumentos adicionais.
Por exemplo, o
[JsonCodec]({{site.dart-api}}/dart-convert/JsonCodec-class.html)
adiciona argumentos nomeados para `encode()` e `decode()`
para tornar esses métodos mais úteis:

```dart
dynamic decode(String source, {reviver(var key, var value)}) { … }
String encode(Object value, {toEncodable(var object)}) { … }
```

O codec pode ser instanciado com argumentos que são usados como valores
padrão, a menos que sejam substituídos pelos argumentos nomeados durante a
chamada de `encode()`/`decode()`.

```dart
const JsonCodec({reviver(var key, var value), toEncodable(var object)})
  ...
```

Como regra geral: se um codec pode ser configurado, ele deve adicionar
argumentos nomeados aos métodos `encode()`/`decode()` e permitir que seus
valores padrão sejam definidos nos construtores. Quando possível, os
construtores de codec devem ser construtores `const`.

## Converter {:#converter}

Conversores, e em particular seus métodos `convert()`, são
onde as conversões reais acontecem:

```dart
T convert(S input);  // onde T é o tipo de destino e S o tipo de origem.
```

Uma implementação de conversor mínima só precisa estender a classe
[Converter]({{site.dart-api}}/dart-convert/Converter-class.html) e
implementar o método `convert()`. Semelhante à classe Codec, os conversores
podem ser configurados estendendo os construtores e adicionando argumentos
nomeados ao método `convert()`.

Tal conversor mínimo funciona em configurações síncronas, mas
não funciona quando usado com chunks (pedaços) (síncrona ou assincronamente).
Em particular, um conversor tão simples não funciona como um transformer
(uma das características mais interessantes dos Conversores). Um conversor totalmente implementado implementa a interface
[StreamTransformer]({{site.dart-api}}/dart-async/StreamTransformer-class.html)
e, portanto, pode ser dado ao método `Stream.transform()`.

Provavelmente, o caso de uso mais comum é a decodificação de UTF-8 com
[utf8.decoder]({{site.dart-api}}/dart-convert/Utf8Codec-class.html):

```dart
File.openRead().transform(utf8.decoder).
```

## Conversão em partes (Chunked conversion) {:#chunked-conversion}

O conceito de conversões em partes (chunked conversions) pode ser confuso, mas,
em sua essência, é relativamente simples. Quando uma conversão em partes
(incluindo uma transformação de stream) é iniciada, o método
[startChunkedConversion]({{site.dart-api}}/dart-convert/Converter/startChunkedConversion.html)
do conversor é invocado com um _sink_ (sumidouro) de saída como argumento. O
método então retorna um _sink_ de entrada no qual o chamador
coloca os dados.

![Conversão em partes](/assets/img/articles/converters-and-codecs/chunked-conversion.png)

**Nota**: Um asterisco (`*`) no diagrama representa várias chamadas opcionais.

No diagrama, o primeiro passo consiste em criar um `outputSink` que deve ser
preenchido com os dados convertidos. Em seguida, o usuário invoca o método
`startChunkedConversion()` do conversor com o _sink_ de saída. O resultado é
um _sink_ de entrada com métodos `add()` e `close()`.

Em um ponto posterior, o código que iniciou a conversão em partes invoca,
possivelmente várias vezes, o método `add()` com alguns dados. Os dados são
convertidos pelo _sink_ de entrada. Se os dados convertidos estiverem prontos,
o _sink_ de entrada os envia para o _sink_ de saída, possivelmente com várias
chamadas `add()`. Eventualmente, o usuário termina a conversão invocando
`close()`. Neste ponto, quaisquer dados convertidos restantes são enviados
do _sink_ de entrada para o _sink_ de saída e o _sink_ de saída é fechado.

Dependendo do conversor, o _sink_ de entrada pode precisar armazenar em buffer
partes dos dados recebidos. Por exemplo, um divisor de linha que recebe
`ab\ncd` como o primeiro pedaço (chunk) pode invocar com segurança seu _sink_ de
saída com `ab`, mas precisa esperar pelos próximos dados (ou pela chamada
`close()`) antes que possa lidar com `cd`. Se os próximos dados forem `e\nf`, o
_sink_ de entrada deve concatenar `cd` e `e` e invocar o _sink_ de saída com a
string `cde`, enquanto armazena em buffer `f` para o próximo evento de dados (ou a chamada `close()`).

A complexidade do _sink_ de entrada (em combinação com o conversor) varia. Algumas conversões em partes
são trivialmente mapeadas para as versões não em partes (como um conversor String→String que remove o
caractere `a`), enquanto outras são mais complicadas. Uma maneira segura, embora ineficiente
(e geralmente não recomendada), de implementar a conversão em partes é armazenar em
buffer e concatenar todos os dados recebidos e fazer a conversão
de uma só vez. É assim que o decodificador JSON está
atualmente (janeiro de 2014) implementado.

Curiosamente, o tipo de conversão em partes não pode ser extrapolado de sua
conversão síncrona. Por exemplo, o conversor
[HtmlEscape]({{site.dart-api}}/dart-convert/HtmlEscape-class.html)
converte síncronamente Strings para Strings,
e assincronamente converte partes
de Strings para partes de Strings (String→String). O conversor
[LineSplitter]({{site.dart-api}}/dart-convert/LineSplitter-class.html)
converte síncronamente Strings para List\<String> (as linhas individuais).
Apesar da diferença na assinatura síncrona,
a versão em partes do conversor
LineSplitter tem a mesma assinatura que
HtmlEscape: String→String. Neste caso,
cada parte de saída individual representa uma linha.

```dart
import 'dart:convert';
import 'dart:async';

void main() async {
  // HtmlEscape converte síncronamente Strings para Strings.
  print(const HtmlEscape().convert("foo")); // "foo".
  // Quando usado de forma fragmentada, converte de Strings
  // para Strings.
  var stream = new Stream.fromIterable(["f", "o", "o"]);
  print(await (stream.transform(const HtmlEscape())
                     .toList()));    // ["f", "o", "o"].

  // LineSplitter converte síncronamente Strings para Listas de String.
  print(const LineSplitter().convert("foo\nbar")); // ["foo", "bar"]
  // No entanto, assincronamente ele converte de Strings para Strings (e
  // não Listas de Strings).
  var stream2 = new Stream.fromIterable(["fo", "o\nb", "ar"]);
  print("${await (stream2.transform(const LineSplitter())
                          .toList())}");
}
```

Em geral, o tipo de conversão em partes é determinado pelo caso mais útil
quando usado como um StreamTransformer.

### ChunkedConversionSink {:#chunkedconversionsink}

[ChunkedConversionSinks]({{site.dart-api}}/dart-convert/ChunkedConversionSink-class.html)
são usados para adicionar novos dados a
um conversor ou como saída de conversores. O ChunkedConversionSink básico vem com
dois métodos: `add()` e `close()`. Estes têm a mesma funcionalidade que em
todos os outros _sinks_ do sistema, como
[StringSinks]({{site.dart-api}}/dart-core/StringSink-class.html)
ou
[StreamSinks]({{site.dart-api}}/dart-async/StreamSink-class.html).

A semântica de ChunkedConversionSinks é semelhante à de
[IOSinks]({{site.dart-api}}/dart-io/IOSink-class.html):
os dados adicionados ao
_sink_ não devem ser modificados, a menos que possa ser garantido que os dados
foram tratados. Para Strings, isso não é um problema (já que são imutáveis), mas
para listas de bytes, geralmente significa alocar uma nova cópia da lista. Isso
pode ser ineficiente e a biblioteca dart:convert, portanto, vem com subclasses
de ChunkedConversionSink que suportam maneiras mais eficientes de passar dados.

Por exemplo, o
[ByteConversionSink]({{site.dart-api}}/dart-convert/ByteConversionSink-class.html),
tem o método adicional:

```dart
void addSlice(List<int> chunk, int start, int end, bool isLast);
```

Semanticamente, ele
aceita uma lista (que não pode ser mantida), o subintervalo sobre o qual o
conversor opera e um booleano `isLast`, que pode ser definido em vez de
chamar `close()`.

```dart
import 'dart:convert';

void main() {
  var outSink = new ChunkedConversionSink.withCallback((chunks) {
    print(chunks.single); // 𝅘𝅥𝅯
  });

  var inSink = utf8.decoder.startChunkedConversion(outSink);
  var list = [0xF0, 0x9D];
  inSink.addSlice(list, 0, 2, false);
  // Já que usamos `addSlice`, podemos reutilizar a lista.
  list[0] = 0x85;
  list[1] = 0xA1;
  inSink.addSlice(list, 0, 2, true);
}
```

Como um usuário do _sink_ de conversão em partes (que é usado tanto como entrada
quanto como saída de conversores), isso simplesmente oferece mais opções. O
fato de que a lista não é mantida significa que você pode usar um cache e
reutilizá-lo para cada chamada. A combinação de `add()` com `close()` pode
ajudar o receptor, pois pode evitar o armazenamento em buffer de dados. Aceitar
sublistas evita chamadas caras para `subList()` (para copiar os dados).

A desvantagem desta interface é que ela é mais complicada de implementar. Para
aliviar a dor dos desenvolvedores, cada _sink_ de conversão em partes aprimorado
do dart:convert também vem com uma classe base que implementa todos os métodos
exceto um (que é abstrato). O implementador do _sink_ de conversão pode então
decidir se deseja aproveitar os métodos adicionais.

**Nota**: _Os _sinks_ de conversão em partes *devem* estender a classe base
correspondente. Isso garante que a adição de funcionalidade às interfaces de
_sink_ existentes não interrompa os _sinks_ estendidos._

## Exemplo {:#example}

Esta seção mostra todas as etapas necessárias para criar um conversor de
criptografia simples e como um ChunkedConversionSink personalizado pode melhorar o desempenho.

Vamos começar com o conversor síncrono simples, cuja rotina de criptografia
simplesmente rotaciona bytes pela chave fornecida:

```dart
import 'dart:convert';

/// Uma extensão simples de Rot13 para bytes e uma chave.
class RotConverter extends Converter<List<int>, List<int>> {
  final _key;
  const RotConverter(this._key);

  List<int> convert(List<int> data, { int key }) {
    if (key == null) key = this._key;
    var result = new List<int>(data.length);
    for (int i = 0; i < data.length; i++) {
      result[i] = (data[i] + key) % 256;
    }
    return result;
  }
}
```

A classe Codec correspondente também é simples:

```dart
class Rot extends Codec<List<int>, List<int>> {
  final _key;
  const Rot(this._key);

  List<int> encode(List<int> data, { int key }) {
    if (key == null) key = this._key;
    return new RotConverter(key).convert(data);
  }

  List<int> decode(List<int> data, { int key }) {
    if (key == null) key = this._key;
    return new RotConverter(-key).convert(data);
  }

  RotConverter get encoder => new RotConverter(_key);
  RotConverter get decoder => new RotConverter(-_key);
}
```

Podemos (e devemos) evitar algumas das alocações `new`, mas, para simplificar,
alocamos uma nova instância de RotConverter sempre que uma é necessária.

É assim que usamos o codec Rot:

```dart
const Rot ROT128 = const Rot(128);
const Rot ROT1 = const Rot(1);

void main() {
  print(const RotConverter(128).convert([0, 128, 255, 1]));   // [128, 0, 127, 129]
  print(const RotConverter(128).convert([128, 0, 127, 129])); // [0, 128, 255, 1]
  print(const RotConverter(-128).convert([128, 0, 127, 129]));// [0, 128, 255, 1]

  print(ROT1.decode(ROT1.encode([0, 128, 255, 1])));          // [0, 128, 255, 1]
  print(ROT128.decode(ROT128.encode([0, 128, 255, 1])));      // [0, 128, 255, 1]
}
```

Estamos no caminho certo. O codec funciona, mas ainda está faltando a parte de
codificação em partes. Como cada byte é codificado separadamente, podemos
recorrer ao método de conversão síncrona:

```dart
class RotConverter {
  ...
  RotSink startChunkedConversion(sink) {
    return new RotSink(_key, sink);
  }
}

class RotSink extends ChunkedConversionSink<List<int>> {
  final _converter;
  final ChunkedConversionSink<List<int>> _outSink;
  RotSink(key, this._outSink) : _converter = new RotConverter(key);

  void add(List<int> data) {
    _outSink.add(_converter.convert(data));
  }

  void close() {
    _outSink.close();
  }
}
```

Agora, podemos usar o conversor com conversões em partes ou mesmo para
transformações de stream:

```dart
import 'dart:io';

void main(List<String> args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  new File(inFile)
    .openRead()
    .transform(new RotConverter(key))
    .pipe(new File(outFile).openWrite());
}
```

### ChunkedConversionSinks Especializados {:#specialized-chunkedconversionsinks}

Para muitos propósitos, a versão atual do Rot é suficiente. Ou seja, o
benefício das melhorias seria superado pelo custo de código mais complexo e
requisitos de teste. No entanto, vamos assumir que o desempenho do conversor
é crítico (está no caminho crítico e no perfil).
Além disso,
assumimos que o custo de alocar uma nova lista para cada
pedaço (chunk) está matando o desempenho
(uma suposição razoável).

Começamos tornando o custo de alocação mais barato: usando uma
[lista de bytes tipada]({{site.dart-api}}/dart-typed_data/Uint8List-class.html)
podemos reduzir o tamanho da lista alocada em um fator de 8 (em máquinas de 64
bits). Esta mudança de uma linha não remove a alocação, mas a torna muito mais
barata.

Também podemos evitar a alocação completamente se sobrescrevermos a entrada.
Na versão a seguir de RotSink, adicionamos um novo método `addModifiable()` que
faz exatamente isso:

```dart
class RotSink extends ChunkedConversionSink<List<int>> {
  final _key;
  final ChunkedConversionSink<List<int>> _outSink;
  RotSink(this._key, this._outSink);

  void add(List<int> data) {
    addModifiable(new Uint8List.fromList(data));
  }

  void addModifiable(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = (data[i] + _key) % 256;
    }
    _outSink.add(data);
  }

  void close() {
    _outSink.close();
  }
}
```

Para simplificar, propomos um novo método que consome uma lista completa. Um
método mais avançado (por exemplo, `addModifiableSlice()`) receberia argumentos
de intervalo (`from`, `to`) e um booleano `isLast` como argumentos.

Este novo método ainda não é usado por transformers, mas já podemos usá-lo ao
invocar `startChunkedConversion()` explicitamente.

```dart
void main() {
  var outSink = new ChunkedConversionSink.withCallback((chunks) {
    print(chunks); // [[31, 32, 33], [24, 25, 26]]
  });
  var inSink = new RotConverter(30).startChunkedConversion(outSink);
  inSink.addModifiable([1, 2, 3]);
  inSink.addModifiable([250, 251, 252]);
  inSink.close();
}
```

Neste pequeno exemplo, o desempenho não é visivelmente diferente,
mas internamente a
conversão em partes evita a alocação de novas listas para os pedaços
(chunks) individuais. Para dois pedaços pequenos, não faz diferença, mas se
implementarmos isso para o stream transformer, a criptografia de um arquivo
maior pode ser notavelmente mais rápida.

Para fazer isso,
podemos usar o recurso não documentado de que IOStreams fornece listas
modificáveis. Agora, poderíamos simplesmente reescrever `add()` e
apontá-lo diretamente para `addModifiable()`. Em geral, isso não é seguro
e tal
conversor seria a fonte potencial de bugs difíceis de rastrear. Em vez disso,
escrevemos um conversor que faz a conversão não modificável para modificável
explicitamente e, em seguida, fundimos os dois conversores.

```dart
class ToModifiableConverter extends Converter<List<int>, List<int>> {
  List<int> convert(List<int> data) => data;
  ToModifiableSink startChunkedConversion(RotSink sink) {
    return new ToModifiableSink(sink);
  }
}

class ToModifiableSink
    extends ChunkedConversionSink<List<int>, List<int>> {
  final RotSink sink;
  ToModifiableSink(this.sink);

  void add(List<int> data) { sink.addModifiable(data); }
  void close() { sink.close(); }
}
```

ToModifiableSink apenas sinaliza para o próximo _sink_ que o pedaço
(chunk) de entrada é modificável. Podemos usar isso para tornar nosso pipeline mais eficiente:

```dart
void main(List<String> args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  new File(inFile)
      .openRead()
      .transform(
          new ToModifiableConverter().fuse(new RotConverter(key)))
      .pipe(new File(outFile).openWrite());
}
```

Na minha máquina, esta pequena modificação reduziu o tempo de criptografia de
um arquivo de 11 MB de 450ms para 260ms. Conseguimos esse aumento de velocidade
sem perder a compatibilidade com os codecs existentes (com relação ao método
`fuse()`) e o conversor ainda funciona como um stream transformer.

Reutilizar a entrada funciona bem com outros
conversores e não apenas com nosso cifrador Rot. Portanto, devemos criar uma
interface que generalize o conceito. Para simplificar, chamamos de
`CipherSink`, embora tenha, é claro, usos fora do mundo da criptografia.

```dart
abstract class CipherSink
    extends ChunkedConversionSink<List<int>, List<int>> {
  void addModifiable(List<int> data) { add(data); }
}
```

Podemos então tornar nosso RotSink privado e expor o CipherSink em vez disso.
Outros desenvolvedores podem agora reutilizar nosso trabalho (CipherSink e
ToModifiableConverter) e se beneficiar dele.

Mas ainda não terminamos.

Embora não tornemos mais o cifrador mais rápido, podemos melhorar o lado da
saída do nosso conversor Rot. Tome, por exemplo, a fusão de duas
criptografias:

```dart
void main(List<String> args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  // Cifragem de força dupla executando o cifrador Rot duas vezes.
  var transformer = new ToModifiableConverter()
       .fuse(new RotConverter(key))  // <= RotConverters fundidos.
       .fuse(new RotConverter(key));
  new File(inFile)
      .openRead()
      .transform(transformer)
      .pipe(new File(outFile).openWrite());
}
```

Como o primeiro RotConverter invoca `outSink.add()`, o segundo RotConverter
assume que a entrada não pode ser modificada e aloca uma cópia. Podemos
contornar isso intercalando um ToModifiableConverter entre os dois cifradores:

```dart
  var transformer = new ToModifiableConverter()
       .fuse(new RotConverter(key))
       .fuse(new ToModifiableConverter())
       .fuse(new RotConverter(key));
```

Isso funciona, mas é gambiarra. Queremos que os RotConverters funcionem sem
conversores intermediários. O primeiro cifrador deve olhar para o outSink e
determinar se é um CipherSink ou não. Podemos fazer isso, sempre que
quisermos adicionar um novo pedaço (chunk), ou no início quando iniciamos
uma conversão em partes.
Preferimos a última abordagem:

```dart
  /// Funciona de forma mais eficiente se receber um CipherSink como argumento.
  CipherSink startChunkedConversion(
      ChunkedConversionSink<List<int>> sink) {
    if (sink is! CipherSink) sink = new _CipherSinkAdapter(sink);
    return new _RotSink(_key, sink);
  }
```

_CipherSinkAdapter é simplesmente:

```dart
class _CipherSinkAdapter implements CipherSink {
  ChunkedConversionSink<List<int>, List<int>> sink;
  _CipherSinkAdapter(this.sink);

  void add(data) { sink.add(data); }
  void addModifiable(data) { sink.add(data); }
  void close() { sink.close(); }
}
```

Agora, só precisamos alterar o _RotSink para aproveitar o fato de que ele
sempre recebe um CipherSink como um argumento para seu construtor:

```dart
class _RotSink extends CipherSink {
  final _key;
  final CipherSink _outSink;  // <= sempre um CipherSink.
  _RotSink(this._key, this._outSink);

  void add(List<int> data) {
    addModifiable(data.toList());
  }

  void addModifiable(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = (data[i] + _key) % 256;
    }
    _outSink.addModifiable(data);  // <= seguro para chamar addModifiable.
  }

  void close() {
    _outSink.close();
  }
}
```

Com essas alterações, nosso cifrador duplo super seguro não alocará nenhuma
nova lista e nosso trabalho estará concluído.

Graças a Lasse Reichstein Holst Nielsen, Anders Johnsen e Matias Meno, que
foram de grande ajuda na redação deste artigo.
