---
ia-translate: true
title: Visão geral do Dart
description: Uma breve introdução ao Dart.
showBreadcrumbs: false
---

<img
  class="light-mode-visible"
  style="padding: 30px; float: right; width: 300px"
  src="/assets/img/logo_lockup_dart_horizontal.png"
  alt="Dart product logo">
<img
  class="dark-mode-visible"
  style="padding: 30px; float: right; width: 300px"
  src="/assets/img/logo/logo-white-text.svg"
  alt="Dart product logo">


Dart é uma linguagem otimizada para clientes para desenvolver aplicativos rápidos em qualquer plataforma.
Seu objetivo é oferecer a linguagem de programação mais produtiva para
desenvolvimento multiplataforma, combinada com uma
[plataforma de runtime de execução flexível](#platform) para frameworks de aplicativos.

As linguagens são definidas por seu _envelope técnico_—as
escolhas feitas durante o desenvolvimento que
moldam as capacidades e os pontos fortes de uma linguagem.
Dart é projetado para um envelope técnico que é
particularmente adequado para desenvolvimento de clientes,
priorizando tanto o desenvolvimento (hot reload com estado em subsegundos) quanto
experiências de produção de alta qualidade em
uma ampla variedade de alvos de compilação (web, mobile e desktop).

Dart também forma a base do [Flutter]({{site.flutter}}).
Dart fornece a linguagem e os runtimes que alimentam os aplicativos Flutter,
mas Dart também oferece suporte a muitas tarefas principais do desenvolvedor, como
formatação, análise e teste de código.


## Dart: A linguagem {:#language}

A linguagem Dart é type safe;
ela usa verificação estática de tipos para garantir que
o valor de uma variável _sempre_ corresponda ao tipo estático da variável.
Às vezes, isso é chamado de sound typing.
Embora os tipos sejam obrigatórios,
anotações de tipo são opcionais devido à inferência de tipo.
O sistema de tipos do Dart também é flexível,
permitindo o uso de um tipo `dynamic` combinado com verificações em runtime,
o que pode ser útil durante experimentação ou
para código que precisa ser especialmente dinâmico.

Dart tem [sound null safety](/null-safety) integrado.
Isso significa que os valores não podem ser null, a menos que você diga que podem ser.
Com sound null safety, Dart pode protegê-lo de
exceções null em runtime através de análise estática de código.
Ao contrário de muitas outras linguagens null-safe,
quando Dart determina que uma variável é não-anulável,
essa variável nunca pode ser null.
Se você inspecionar seu código em execução no debugger,
você verá que a não-anulabilidade é mantida em runtime; daí _sound_ null safety.

O exemplo de código a seguir mostra vários recursos da linguagem Dart,
incluindo bibliotecas, chamadas async, tipos anuláveis e não-anuláveis,
arrow syntax, generators, streams e getters.
Para saber mais sobre a linguagem,
confira o [tour pela linguagem Dart](/language).

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
    // We consider only non-negative x and y (that is, the
    // first quadrant), which doesn't change the ratio.
    // So, when given random points with x ∈ [0, 1],
    // y ∈ [0, 1], the ratio of those inside the unit circle
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
fornecendo recursos essenciais para muitas tarefas de programação do dia a dia:

* Tipos integrados, coleções e outras funcionalidades principais para
  todo programa Dart
  (`dart:core`)
* Tipos de coleção mais ricos, como filas, listas ligadas, hashmaps e
  árvores binárias
  (`dart:collection`)
* Encoders e decoders para converter entre diferentes representações de dados,
  incluindo JSON e UTF-8
  (`dart:convert`)
* Constantes e funções matemáticas e geração de números aleatórios
  (`dart:math`)
* Suporte para programação assíncrona,
  com classes como `Future` e `Stream`
  (`dart:async`)
* Listas que lidam eficientemente com dados de tamanho fixo
  (por exemplo, inteiros de 8 bytes sem sinal) e tipos numéricos SIMD
  (`dart:typed_data`)
* Suporte para arquivo, socket, HTTP e outras operações de I/O para aplicações não-web
  (`dart:io`)
* Interfaces de função estrangeira para interoperabilidade com
  outro código que apresenta uma interface no estilo C
  (`dart:ffi`)
* Programação concorrente usando _isolates_—workers independentes
  que são semelhantes a threads, mas
  não compartilham memória, comunicando-se apenas por meio de mensagens
  (`dart:isolate`)
* Elementos HTML e outros recursos para aplicações baseadas na web que precisam
  interagir com o navegador e o Document Object Model (DOM)
  (`dart:js_interop` e `package:web`)

Além das bibliotecas principais, muitas APIs são fornecidas através de
um conjunto abrangente de pacotes.
A equipe Dart publica muitos pacotes suplementares úteis,
como estes:

* [characters]({{site.pub-pkg}}/characters)
* [intl]({{site.pub-pkg}}/intl)
* [http]({{site.pub-pkg}}/http)
* [crypto]({{site.pub-pkg}}/crypto)
* [markdown]({{site.pub-pkg}}/markdown)

Além disso, editores terceiros e a comunidade mais ampla
publicam milhares de pacotes, com suporte para recursos como estes:

* [XML]({{site.pub-pkg}}/xml)
* [Windows integration]({{site.pub-pkg}}/win32)
* [SQLite]({{site.pub-pkg}}/sqflite_common)
* [compression]({{site.pub-pkg}}/archive)

Para ver uma série de exemplos funcionais apresentando as bibliotecas principais do Dart,
leia a [documentação das bibliotecas principais](/libraries).
Para encontrar APIs adicionais, confira a
[página de pacotes comumente usados](/resources/useful-packages).


## Dart: As plataformas {:#platform}

A tecnologia de compilador do Dart permite que você execute código de diferentes maneiras:

* **Plataforma nativa**: Para aplicativos direcionados a dispositivos móveis e desktop,
  Dart inclui tanto uma Dart VM com compilação just-in-time (JIT) quanto
  um compilador ahead-of-time (AOT) para produzir código de máquina.

* **Plataforma web**: Para aplicativos direcionados à web, Dart pode compilar para
  fins de desenvolvimento ou produção. Seus compiladores web traduzem Dart
  para JavaScript ou WebAssembly.

<img
  src="/assets/img/Dart-platforms.svg"
  width="800"
  alt="An illustration of the targets supported by Dart">

O [framework Flutter]({{site.flutter}}) é um popular
toolkit de UI multiplataforma alimentado pela plataforma Dart,
e que fornece ferramentas e bibliotecas de UI para construir experiências de UI que são executadas
no iOS, Android, macOS, Windows, Linux e na web.

#### Dart Native (código de máquina JIT e AOT) {:#native-platform}

Durante o desenvolvimento, um ciclo rápido de desenvolvedor é crítico para iteração.
A Dart VM oferece um compilador just-in-time (JIT) com
recompilação incremental (habilitando hot reload), coleta de métricas ao vivo
(alimentando [DevTools](/tools/dart-devtools)) e suporte rico de depuração.

Quando os aplicativos estão prontos para serem implantados em produção—seja você
publicando em uma loja de aplicativos ou implantando em um backend de produção—o
compilador ahead-of-time (AOT) do Dart pode compilar para código de máquina ARM ou x64
nativo. Seu aplicativo compilado com AOT inicia com tempo de
inicialização consistente e curto.

O código compilado com AOT é executado dentro de um runtime Dart eficiente que
impõe o sound Dart type system e
gerencia a memória usando alocação rápida de objetos e um
[coletor de lixo geracional](https://medium.com/flutter-io/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30).

Mais informações:
* [Primeiros passos: Aplicativos de linha de comando e servidor](/tutorials/server/get-started)
* [Ferramenta `dart` para executar com JIT ou compilação AOT para código de máquina](/tools/dart-tool)
* [Escrever aplicativos de linha de comando](/tutorials/server/cmdline)
* [Escrever servidores HTTP](/tutorials/server/httpserver)

#### Dart Web (JavaScript dev & prod e WebAssembly) {:#web-platform}

Dart Web permite executar código Dart em plataformas web alimentadas por
JavaScript. Com Dart Web, você compila código Dart para código JavaScript, que por sua vez
é executado em um navegador—por exemplo, [V8](https://v8.dev/) dentro do
[Chrome](https://www.google.com/chrome/).
Alternativamente, o código Dart pode ser compilado para WebAssembly.

Dart web contém três modos de compilação:

* Um compilador JavaScript incremental de desenvolvimento que habilita um ciclo de desenvolvedor
  rápido com recompilação incremental (habilitando hot reload).
* Um compilador JavaScript otimizador de produção que compila código Dart para JavaScript rápido,
  compacto e implantável. Essas eficiências vêm de técnicas como
  eliminação de código morto.
* Um compilador WebAssembly (WasmGC) otimizador de produção que compila código Dart
  para código WebAssembly GC super-rápido e implantável.

Mais informações:

* [Construir um aplicativo web com Dart](/web/get-started)
* [`dart compile js`](/tools/dart-compile#js)
* [Ferramenta `webdev`](/tools/webdev)
* [Dicas de implantação web](/web/deployment)
* [Compilação WebAssembly](/web/wasm)

#### O runtime Dart {:#runtime}

Independentemente de qual plataforma você usa ou como você compila seu código,
executar o código requer um runtime Dart.
Este runtime é responsável pelas seguintes tarefas críticas:

* Gerenciar memória:
  Dart usa um modelo de memória gerenciada,
  onde a memória não utilizada é recuperada por um coletor de lixo (GC).

* Impor o Dart type system:
  Embora a maioria das verificações de tipo no Dart sejam estáticas (tempo de compilação),
  algumas verificações de tipo são dinâmicas (runtime).
  Por exemplo, o runtime Dart impõe verificações dinâmicas por meio de
  [operadores de verificação de tipo e cast](/language/operators#type-test-operators).

* Gerenciar [isolates](/language/concurrency):
  O runtime Dart controla o isolate principal (onde o código normalmente é executado)
  e quaisquer outros isolates que o aplicativo criar.

Em plataformas nativas, o runtime Dart é automaticamente
incluído dentro de executáveis autocontidos,
e é parte da Dart VM fornecida pelo
comando [`dart run`](/tools/dart-run).

## Aprendendo Dart {:#learning-dart}

Você tem muitas opções para aprender Dart. Aqui estão algumas que recomendamos:

* [Explore Dart no navegador]({{site.dartpad}}/) através do DartPad,
  um ambiente de execução baseado na web para código Dart.
* [Faça um tour pela linguagem Dart](/language),
  que mostra como usar cada recurso principal do Dart.
* [Complete um tutorial do Dart](/tutorials/server/cmdline) que
  cobre os fundamentos do uso de Dart para construir para a linha de comando.
* [Trabalhe em um treinamento online extenso][udemy]
  de especialistas em Dart.
* [Explore a documentação da API]({{site.dart-api}}) que
  descreve as bibliotecas principais do Dart.
* [Leia um livro sobre programação Dart](/resources/books).

[udemy]: https://www.udemy.com/course/complete-dart-guide/?couponCode=NOV-20
