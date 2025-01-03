---
ia-translate: true
title: Visão geral do Dart
description: Uma breve introdução ao Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
---

<img
  style="padding: 30px; float: right; width: 300px"
  src="/assets/img/logo_lockup_dart_horizontal.png"
  alt="Dart product logo">

Dart é uma linguagem otimizada para cliente (client-optimized)
para desenvolver aplicativos rápidos em qualquer plataforma.
Seu objetivo é oferecer a linguagem de programação mais produtiva para desenvolvimento multiplataforma,
juntamente com uma [plataforma de tempo de execução flexível](#platform) para frameworks de aplicativos.

As linguagens são definidas por seu _envelope técnico_—as
escolhas feitas durante o desenvolvimento que
moldam os recursos e os pontos fortes de uma linguagem.
Dart é projetado para um envelope técnico que é
particularmente adequado para o desenvolvimento do cliente,
priorizando o desenvolvimento (hot reload stateful (com estado) em menos de um segundo) e
experiências de produção de alta qualidade em
uma ampla variedade de destinos de compilação (web, mobile e desktop).

Dart também forma a base do [Flutter]({{site.flutter}}).
Dart fornece a linguagem e os tempos de execução que alimentam os aplicativos Flutter,
mas o Dart também suporta muitas tarefas essenciais do desenvolvedor, como
formatação, análise e teste de código.


## Dart: A linguagem {:#language}

A linguagem Dart é type safe;
ela usa verificação de tipo estática para garantir que
o valor de uma variável _sempre_ corresponda ao tipo estático da variável.
Às vezes, isso é chamado de tipagem sólida.
Embora os tipos sejam obrigatórios,
as anotações de tipo são opcionais devido à inferência de tipo.
O sistema de tipagem do Dart também é flexível,
permitindo o uso de um tipo `dynamic` combinado com verificações de tempo de execução,
o que pode ser útil durante a experimentação ou
para código que precisa ser especialmente dinâmico.

Dart tem [sound null safety](/null-safety) incorporada.
Isso significa que os valores não podem ser nulos, a menos que você diga que podem ser.
Com sound null safety, o Dart pode protegê-lo de
exceções nulas em tempo de execução por meio da análise estática de código.
Ao contrário de muitas outras linguagens null-safe,
quando o Dart determina que uma variável não é anulável,
essa variável nunca pode ser nula.
Se você inspecionar seu código em execução no depurador,
verá que a não nulidade é mantida em tempo de execução; daí _sound_ null safety.

O seguinte exemplo de código mostra vários recursos da linguagem Dart,
incluindo bibliotecas, chamadas assíncronas, tipos anuláveis e não anuláveis,
sintaxe de seta (arrow syntax), geradores, streams e getters.
Para aprender mais sobre a linguagem,
confira o [tour da linguagem Dart](/language).

<?code-excerpt "misc/lib/overview_pi.dart"?>
```dartpad
import 'dart:math' show Random;

void main() async {
  print('Compute π using the Monte Carlo method.');
  await for (final estimate in computePi().take(100)) {
    print('π ≅ $estimate');
  }
}

/// Generates a stream of increasingly accurate estimates of π.
Stream<double> computePi({int batch = 100000}) async* {
  var total = 0; // Inferred to be of type int
  var count = 0;
  while (true) {
    final points = generateRandom().take(batch);
    final inside = points.where((p) => p.isInsideUnitCircle);

    total += batch;
    count += inside.length;
    final ratio = count / total;

    // Area of a circle is A = π⋅r², therefore π = A/r².
    // So, when given random points with x ∈ <0,1>,
    // y ∈ <0,1>, the ratio of those inside a unit circle
    // should approach π / 4. Therefore, the value of π
    // should be:
    yield ratio * 4;
  }
}

Iterable<Point> generateRandom([int? seed]) sync* {
  final random = Random(seed);
  while (true) {
    yield Point(random.nextDouble(), random.nextDouble());
  }
}

class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  bool get isInsideUnitCircle => x * x + y * y <= 1;
}
```

:::note
Este exemplo está sendo executado em um [DartPad](/tools/dartpad) incorporado.
Você também pode
<a href="{{site.dartpad}}/?id=bc63d212c3252e44058ff76f34ef5730"
target="_blank" rel="noopener">abrir este exemplo em sua própria janela</a>.
:::


## Dart: As bibliotecas {:#libraries}

Dart tem [um rico conjunto de bibliotecas principais](/libraries),
fornecendo o essencial para muitas tarefas de programação do dia a dia:

* Tipos integrados, coleções e outras funcionalidades básicas para
  cada programa Dart
  (`dart:core`)
* Tipos de coleção mais ricos, como filas, listas vinculadas, mapas de hash e
  árvores binárias
  (`dart:collection`)
* Codificadores e decodificadores para conversão entre diferentes representações de dados,
  incluindo JSON e UTF-8
  (`dart:convert`)
* Constantes e funções matemáticas e geração de números aleatórios
  (`dart:math`)
* Suporte para programação assíncrona,
  com classes como `Future` e `Stream`
  (`dart:async`)
* Listas que lidam com eficiência com dados de tamanho fixo
  (por exemplo, inteiros de 8 bits não assinados) e tipos numéricos SIMD
  (`dart:typed_data`)
* Suporte a arquivos, soquetes, HTTP e outras E/S para aplicativos não web
  (`dart:io`)
* Interfaces de função estrangeira para interoperabilidade com
  outro código que apresenta uma interface estilo C
  (`dart:ffi`)
* Programação simultânea usando _isolates_—trabalhadores independentes
  que são semelhantes a threads, mas
  não compartilham memória, comunicando-se apenas por meio de mensagens
  (`dart:isolate`)
* Elementos HTML e outros recursos para aplicativos baseados na web que precisam
  interagir com o navegador e o Document Object Model (DOM)
  (`dart:html`)

Além das bibliotecas principais, muitas APIs são fornecidas por meio de
um conjunto abrangente de pacotes.
A equipe do Dart publica muitos pacotes suplementares úteis,
como estes:

* [characters]({{site.pub-pkg}}/characters)
* [intl]({{site.pub-pkg}}/intl)
* [http]({{site.pub-pkg}}/http)
* [crypto]({{site.pub-pkg}}/crypto)
* [markdown]({{site.pub-pkg}}/markdown)

Além disso, editores terceirizados e a comunidade em geral
publicam milhares de pacotes, com suporte para recursos como estes:

* [XML]({{site.pub-pkg}}/xml)
* [Integração com Windows]({{site.pub-pkg}}/win32)
* [SQLite]({{site.pub-pkg}}/sqflite_common)
* [compressão]({{site.pub-pkg}}/archive)

Para ver uma série de exemplos funcionais com as bibliotecas principais do Dart,
leia a [documentação da biblioteca principal](/libraries).
Para encontrar APIs adicionais, confira a
[página de pacotes comumente usados](/resources/useful-packages).


## Dart: As plataformas {:#platform}

A tecnologia de compilador do Dart permite que você execute o código de diferentes maneiras:

* **Plataforma nativa**: para aplicativos destinados a dispositivos móveis e desktop,
  O Dart inclui uma Dart VM com compilação just-in-time (JIT) e
  um compilador ahead-of-time (AOT) para produzir código de máquina.

* **Plataforma Web**: para aplicativos destinados à web, o Dart pode compilar para
  fins de desenvolvimento ou produção. Seus compiladores web traduzem Dart
  em JavaScript ou WebAssembly.

<img
  src="/assets/img/Dart-platforms.svg"
  width="800"
  alt="Uma ilustração dos alvos suportados pelo Dart">

O [framework Flutter]({{site.flutter}}) é um popular
kit de ferramentas de interface do usuário multiplataforma que é alimentado pela plataforma Dart,
e que fornece ferramentas e bibliotecas de interface do usuário para construir experiências de interface do usuário que são executadas
em iOS, Android, macOS, Windows, Linux e web.

#### Dart Native (código de máquina JIT e AOT) {:#native-platform}

Durante o desenvolvimento, um ciclo de desenvolvimento rápido é crítico para a iteração.
A Dart VM oferece um compilador just-in-time (JIT) com
recompilação incremental (permitindo hot reload), coleta de métricas ao vivo
(alimentando [DevTools](/tools/dart-devtools)) e rico suporte à depuração.

Quando os aplicativos estão prontos para serem implantados na produção —seja
publicando em uma loja de aplicativos ou implantando em um back-end de produção—o
compilador ahead-of-time (AOT) do Dart pode compilar para código de máquina ARM ou x64 nativo.
Seu aplicativo compilado com AOT é iniciado com um
tempo de inicialização curto e consistente.

O código compilado com AOT é executado dentro de um tempo de execução Dart eficiente que
aplica o sistema de tipos Dart e
gerencia a memória usando alocação rápida de objetos e um
[coletor de lixo geracional](https://medium.com/flutter-io/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30).

Mais Informações:
* [Primeiros passos: aplicativos de linha de comando e servidor](/tutorials/server/get-started)
* [ferramenta `dart` para executar com compilação JIT ou AOT para código de máquina](/tools/dart-tool)
* [Escrever aplicativos de linha de comando](/tutorials/server/cmdline)
* [Escrever servidores HTTP](/tutorials/server/httpserver)

#### Dart Web (JavaScript dev & prod e WebAssembly) {:#web-platform}

O Dart Web permite a execução de código Dart em plataformas web alimentadas por
JavaScript. Com o Dart Web, você compila o código Dart em código JavaScript, que por sua vez
é executado em um navegador—por exemplo, [V8](https://v8.dev/) dentro do
[Chrome](https://www.google.com/chrome/).
Alternativamente, o código Dart pode ser compilado para WebAssembly.

O Dart web contém três modos de compilação:

* Um compilador de desenvolvimento JavaScript incremental que permite um ciclo
  de desenvolvimento rápido.
* Um compilador de produção JavaScript otimizado que compila o código Dart para JavaScript rápido,
  compacto e implantável. Essas eficiências vêm de técnicas como
  eliminação de código morto.
* Um compilador de produção WebAssembly (WasmGC) otimizado que compila o Dart
  código para código WebAssembly GC super-rápido e implantável.

Mais Informações:

* [Construir um aplicativo web com Dart](/web/get-started)
* [`dart compile js`](/tools/dart-compile#js)
* [ferramenta `webdev`](/tools/webdev)
* [Dicas de implantação na web](/web/deployment)
* [Compilação WebAssembly](/web/wasm)

#### O tempo de execução Dart {:#runtime}

Independentemente de qual plataforma você usa ou como você compila seu código,
a execução do código requer um tempo de execução Dart.
Este tempo de execução é responsável pelas seguintes tarefas críticas:

* Gerenciamento de memória:
  O Dart usa um modelo de memória gerenciada,
  onde a memória não utilizada é recuperada por um coletor de lixo (GC).

* Impondo o sistema de tipos Dart:
  Embora a maioria das verificações de tipo no Dart sejam estáticas (tempo de compilação),
  algumas verificações de tipo são dinâmicas (tempo de execução).
  Por exemplo, o tempo de execução do Dart impõe verificações dinâmicas por meio de
  [operadores de verificação de tipo e conversão](/language/operators#type-test-operators).

* Gerenciando [isolates](/language/concurrency):
  O tempo de execução do Dart controla o isolate principal (onde o código normalmente é executado)
  e quaisquer outros isolates que o aplicativo cria.

Em plataformas nativas, o tempo de execução do Dart é automaticamente
incluído dentro de executáveis autocontidos,
e faz parte da Dart VM fornecida pelo
comando [`dart run`](/tools/dart-run).

## Aprendendo Dart {:#learning-dart}

Você tem muitas opções para aprender Dart. Aqui estão algumas que recomendamos:

* [Explore o Dart no navegador]({{site.dartpad}}/) por meio do DartPad,
  um ambiente de execução baseado na web para código Dart.
* [Faça um tour da linguagem Dart](/language),
  que mostra como usar cada um dos principais recursos do Dart.
* [Conclua um tutorial do Dart](/tutorials/server/cmdline) que
  cobre o básico do uso do Dart para construir para a linha de comando.
* [Trabalhe com treinamento online extensivo][udemy]
  de especialistas em Dart.
* [Explore a documentação da API]({{site.dart-api}}) que
  descreve as bibliotecas principais do Dart.
* [Leia um livro sobre programação Dart](/resources/books).

[udemy]: https://www.udemy.com/course/complete-dart-guide/?couponCode=NOV-20