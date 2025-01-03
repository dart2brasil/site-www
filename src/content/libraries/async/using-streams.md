---
ia-translate: true
title: "Programação assíncrona: Streams"
description: "Aprenda como consumir streams de inscrição única e de transmissão."
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
---

:::secondary Qual é o objetivo?
* Streams fornecem uma sequência assíncrona de dados.
* As sequências de dados incluem eventos gerados pelo usuário e dados lidos de arquivos.
* Você pode processar um stream usando **await for** ou
  `listen()` da API Stream.
* Streams fornecem uma maneira de responder a erros.
* Existem dois tipos de streams: inscrição única ou transmissão (broadcast).
:::

A programação assíncrona em Dart é caracterizada pelas
classes [Future][] e [Stream][].

Um Future representa uma computação que não é concluída imediatamente.
Onde uma função normal retorna o resultado, uma função assíncrona
retorna um Future, que eventualmente conterá o resultado.
O future informará quando o resultado estiver pronto.

Um stream (fluxo) é uma sequência de eventos assíncronos.
É como um Iterable assíncrono—onde, em vez de obter o próximo
evento quando você o solicita, o stream informa que
há um evento quando ele está pronto.

## Recebendo eventos do stream {:#receiving-stream-events}

Streams podem ser criados de várias maneiras, o que é um tópico para
outro artigo, mas todos eles podem ser usados da mesma forma: o _loop
for assíncrono_ (comumente chamado de **await for**) itera sobre os
eventos de um stream como o **for loop** itera sobre um [Iterable][].
Por exemplo:

<?code-excerpt "misc/lib/tutorial/sum_stream.dart (sum-stream)" replace="/async|await for/[!$&!]/g"?>
```dart
Future<int> sumStream(Stream<int> stream) [!async!] {
  var sum = 0;
  [!await for!] (final value in stream) {
    sum += value;
  }
  return sum;
}
```

Este código simplesmente recebe cada evento de um stream de eventos
inteiros, soma-os e retorna (um future da) a soma.
Quando o corpo do loop termina, a função é pausada até que o próximo
evento chegue ou o stream termine.

A função é marcada com a palavra-chave `async`, que é necessária
ao usar o loop **await for**.

O exemplo a seguir testa o código anterior gerando um stream
simples de inteiros usando uma função `async*`:

:::note
Esta página usa DartPads incorporados para exibir exemplos executáveis.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

<?code-excerpt "misc/lib/tutorial/sum_stream.dart"?>
```dartpad
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (final value in stream) {
    sum += value;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

void main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // 55
}
```

:::note
Clique em **Executar** para ver o resultado no **Console**.
:::

## Eventos de erro {:#error-events}

Streams são concluídos quando não há mais eventos neles,
e o código que recebe os eventos é notificado disso, assim como
é notificado de que um novo evento chega.
Ao ler eventos usando um loop **await for**, os loops param quando
o stream é concluído.

Em alguns casos, ocorre um erro antes que o stream seja concluído;
talvez a rede tenha falhado ao buscar um arquivo de um servidor remoto,
ou talvez o código que cria os eventos tenha um bug,
mas alguém precisa saber disso.

Streams também podem entregar eventos de erro, como entregam eventos de dados.
A maioria dos streams para após o primeiro erro,
mas é possível ter streams que entregam mais de um erro,
e streams que entregam mais dados após um evento de erro.
Neste documento, discutimos apenas streams que entregam no máximo um erro.

Ao ler um stream usando **await for**, o erro é lançado pela
instrução de loop. Isso também finaliza o loop. Você pode capturar o
erro usando **try-catch**. O exemplo a seguir gera um erro
quando o iterador do loop for igual a 4:

<?code-excerpt "misc/lib/tutorial/sum_stream_with_catch.dart"?>
```dartpad
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  try {
    await for (final value in stream) {
      sum += value;
    }
  } catch (e) {
    return -1;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    if (i == 4) {
      throw Exception('Intentional exception');
    } else {
      yield i;
    }
  }
}

void main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // -1
}
```

:::note
Clique em **Executar** para ver o resultado no **Console**.
:::


## Trabalhando com streams {:#working-with-streams}

A classe Stream contém vários métodos auxiliares que podem realizar
operações comuns em um stream para você,
semelhante aos métodos em um [Iterable][].
Por exemplo, você pode encontrar o último inteiro positivo em um stream
usando `lastWhere()` da API Stream.

<?code-excerpt "misc/lib/tutorial/misc.dart (last-positive)"?>
```dart
Future<int> lastPositive(Stream<int> stream) =>
    stream.lastWhere((x) => x >= 0);
```

## Dois tipos de streams {:#two-kinds-of-streams}

Existem dois tipos de streams.

### Streams de inscrição única {:#single-subscription-streams}

O tipo mais comum de stream contém uma sequência de eventos que são
partes de um todo maior.
Os eventos precisam ser entregues na ordem correta e sem perder
nenhum deles.
Este é o tipo de stream que você obtém quando lê um arquivo ou recebe
uma solicitação da web.

Tal stream só pode ser escutado uma vez.
Ouvir novamente mais tarde pode significar perder os eventos iniciais,
e então o resto do stream não faz sentido.
Quando você começa a escutar, os dados serão buscados e fornecidos
em partes.

### Streams de transmissão (Broadcast) {:#broadcast-streams}

O outro tipo de stream é destinado a mensagens individuais que
podem ser tratadas uma de cada vez. Esse tipo de stream pode ser
usado para eventos de mouse em um navegador, por exemplo.

Você pode começar a escutar um stream desse tipo a qualquer momento,
e você obtém os eventos que são disparados enquanto você escuta.
Mais de um ouvinte pode escutar ao mesmo tempo,
e você pode escutar novamente mais tarde depois de cancelar uma
inscrição anterior.

## Métodos que processam um stream {:#process-stream-methods}

Os seguintes métodos em [Stream\<T>][Stream] processam o stream e
retornam um resultado:

<?code-excerpt "misc/lib/tutorial/stream_interface.dart (main-stream-members)" remove="/^\s*Stream/"?>
```dart
Future<T> get first;
Future<bool> get isEmpty;
Future<T> get last;
Future<int> get length;
Future<T> get single;
Future<bool> any(bool Function(T element) test);
Future<bool> contains(Object? needle);
Future<E> drain<E>([E? futureValue]);
Future<T> elementAt(int index);
Future<bool> every(bool Function(T element) test);
Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse});
Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine);
Future forEach(void Function(T element) action);
Future<String> join([String separator = '']);
Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse});
Future pipe(StreamConsumer<T> streamConsumer);
Future<T> reduce(T Function(T previous, T element) combine);
Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse});
Future<List<T>> toList();
Future<Set<T>> toSet();
```

Todas essas funções, exceto `drain()` e `pipe()`,
correspondem a uma função similar em [Iterable][].
Cada uma pode ser escrita facilmente usando uma função `async`
com um loop **await for** (ou apenas usando um dos outros métodos).
Por exemplo, algumas implementações poderiam ser:

<?code-excerpt "misc/lib/tutorial/misc.dart (mock-stream-method-implementations)"?>
```dart
Future<bool> contains(Object? needle) async {
  await for (final event in this) {
    if (event == needle) return true;
  }
  return false;
}

Future forEach(void Function(T element) action) async {
  await for (final event in this) {
    action(event);
  }
}

Future<List<T>> toList() async {
  final result = <T>[];
  await forEach(result.add);
  return result;
}

Future<String> join([String separator = '']) async =>
    (await toList()).join(separator);
```

(As implementações reais são um pouco mais complexas,
mas principalmente por razões históricas.)

## Métodos que modificam um stream {:#modify-stream-methods}

Os seguintes métodos em Stream retornam um novo stream baseado
no stream original.
Cada um espera até que alguém escute o novo stream antes de
escutar o original.

<?code-excerpt "misc/lib/tutorial/stream_interface.dart (main-stream-members)" remove="/async\w+|distinct|transform/" retain="/^\s*Stream/"?>
```dart
Stream<R> cast<R>();
Stream<S> expand<S>(Iterable<S> Function(T element) convert);
Stream<S> map<S>(S Function(T event) convert);
Stream<T> skip(int count);
Stream<T> skipWhile(bool Function(T element) test);
Stream<T> take(int count);
Stream<T> takeWhile(bool Function(T element) test);
Stream<T> where(bool Function(T event) test);
```

Os métodos anteriores correspondem a métodos similares em
[Iterable][] que transformam um iterável em outro iterável.
Todos estes podem ser escritos facilmente usando uma função `async`
com um loop **await for**.

<?code-excerpt "misc/lib/tutorial/stream_interface.dart (main-stream-members)" remove="/transform/" retain="/async\w+|distinct/"?>
```dart
Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert);
Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert);
Stream<T> distinct([bool Function(T previous, T next)? equals]);
```

As funções `asyncExpand()` e `asyncMap()` são similares a
`expand()` e `map()`,
mas permitem que seu argumento de função seja uma função
assíncrona. A função `distinct()` não existe em `Iterable`, mas poderia existir.

<?code-excerpt "misc/lib/tutorial/stream_interface.dart (special-stream-members)"?>
```dart
Stream<T> handleError(Function onError, {bool Function(dynamic error)? test});
Stream<T> timeout(Duration timeLimit,
    {void Function(EventSink<T> sink)? onTimeout});
Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer);
```

As três últimas funções são mais especiais.
Elas envolvem tratamento de erros que um loop **await for**
não pode fazer—o primeiro erro que atinge os loops encerrará
o loop e sua inscrição no stream.
Não há como se recuperar disso.
O código a seguir mostra como usar `handleError()` para remover erros
de um stream antes de usá-lo em um loop **await for**.

<?code-excerpt "misc/lib/tutorial/misc.dart (map-log-errors)"?>
```dart
Stream<S> mapLogErrors<S, T>(
  Stream<T> stream,
  S Function(T event) convert,
) async* {
  var streamWithoutErrors = stream.handleError((e) => log(e));
  await for (final event in streamWithoutErrors) {
    yield convert(event);
  }
}
```

### A função transform() {:#transform-function}

A função `transform()` não serve apenas para tratamento de erros;
é um "map" mais generalizado para streams.
Um map normal requer um valor para cada evento de entrada.
No entanto, especialmente para streams de E/S,
pode ser necessário vários eventos de entrada para produzir um evento de saída.
Um [StreamTransformer][] pode trabalhar com isso.
Por exemplo, decodificadores como [Utf8Decoder][] são transformers (transformadores).
Um transformer requer apenas uma função, [bind()][], que pode ser
facilmente implementada por uma função `async`.

### Lendo e decodificando um arquivo {:#reading-decoding-file}

O código a seguir lê um arquivo e executa duas transformações sobre
o stream.
Primeiro, ele converte os dados de UTF8 e, em seguida, os executa por
meio de um [LineSplitter][].
Todas as linhas são impressas, exceto as que começam com um hashtag, `#`.

<?code-excerpt "misc/bin/cat_no_hash.dart"?>
```dart
import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  var file = File(args[0]);
  var lines = utf8.decoder
      .bind(file.openRead())
      .transform(const LineSplitter());
  await for (final line in lines) {
    if (!line.startsWith('#')) print(line);
  }
}
```

## O método listen() {:#listen-method}

O último método em Stream é `listen()`. Este é um método de "baixo nível"—todas as outras funções de stream são definidas em termos de `listen()`.

<?code-excerpt "misc/lib/tutorial/stream_interface.dart (listen)"?>
```dart
StreamSubscription<T> listen(void Function(T event)? onData,
    {Function? onError, void Function()? onDone, bool? cancelOnError});
```

Para criar um novo tipo `Stream`, você pode simplesmente estender a
classe `Stream` e implementar o método `listen()`—todos os outros
métodos em `Stream` chamam `listen()` para funcionar.

O método `listen()` permite que você comece a escutar um stream.
Até você fazer isso,
o stream é um objeto inerte que descreve quais eventos você deseja ver.
Quando você escuta,
um objeto [StreamSubscription][] é retornado, que representa o
stream ativo produzindo eventos.
Isso é semelhante a como um `Iterable` é apenas uma coleção de objetos,
mas o iterador é quem está fazendo a iteração real.

A assinatura do stream permite pausar a assinatura,
retomá-la após uma pausa,
e cancelá-la completamente.
Você pode definir callbacks para serem chamados para cada evento de
dados ou evento de erro, e quando o stream é fechado.

## Outros recursos {:#other-resources}

Leia a documentação a seguir para obter mais detalhes sobre o uso de
streams e programação assíncrona em Dart.

* [Criando Streams em Dart](/libraries/async/creating-streams),
  um artigo sobre como criar seus próprios streams
* [Futures e Tratamento de Erros](/libraries/async/futures-error-handling),
  um artigo que explica como lidar com erros usando a API Future
* [Suporte à Assincronia](/language/async),
  uma seção no [tour pela linguagem](/language)
* [Referência da API Stream]({{site.dart-api}}/dart-async/Stream-class.html)

[bind()]: {{site.dart-api}}/dart-async/StreamTransformer/bind.html
[LineSplitter]: {{site.dart-api}}/dart-convert/LineSplitter-class.html
[Future]: {{site.dart-api}}/dart-async/Future-class.html
[Iterable]: {{site.dart-api}}/dart-core/Iterable-class.html
[Stream]: {{site.dart-api}}/dart-async/Stream-class.html
[StreamSubscription]: {{site.dart-api}}/dart-async/StreamSubscription-class.html
[StreamTransformer]: {{site.dart-api}}/dart-async/StreamTransformer-class.html
[Utf8Decoder]: {{site.dart-api}}/dart-convert/Utf8Decoder-class.html
