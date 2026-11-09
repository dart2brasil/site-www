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
  alt="Logo do produto Dart">
<img
  class="dark-mode-visible"
  style="padding: 30px; float: right; width: 300px"
  src="/assets/img/logo/logo-white-text.svg"
  alt="Logo do produto Dart">

O Dart é uma linguagem otimizada para clientes, usada para desenvolver aplicações rápidas em qualquer plataforma.
Seu objetivo é oferecer a linguagem de programação mais produtiva para
desenvolvimento multiplataforma, combinada com uma
[plataforma de runtime de execução flexível](#platform) para frameworks de aplicações.

As linguagens são definidas por seu _envelope técnico_: as
escolhas feitas durante o desenvolvimento que
moldam as capacidades e os pontos fortes de uma linguagem.
O Dart foi projetado para um envelope técnico
especialmente adequado ao desenvolvimento de clientes,
priorizando tanto o desenvolvimento (hot reload com estado em menos de um segundo) quanto
experiências de produção de alta qualidade em
uma grande variedade de alvos de compilação (web, mobile e desktop).

O Dart também é a base do [Flutter]({{site.flutter}}).
O Dart fornece a linguagem e os runtimes que alimentam as aplicações Flutter,
mas também oferece suporte a muitas tarefas essenciais do desenvolvedor, como
formatar, analisar e testar código.

:::tip Está começando em programação?
Se você está começando em programação,
alguns conceitos desta página podem ser avançados.
+Considere começar com uma introdução básica:
* Confira os
  [tutoriais de Dart dos Codelabs](https://codelabs.developers.google.com/?cat=Dart)
  com o passo a passo dos fundamentos.
* Dê uma olhada no [Tour pela linguagem](/language), uma introdução,
  para aprender a sintaxe fundamental no seu próprio ritmo.
:::

## Dart: a linguagem {:#language}

A linguagem Dart é type safe;
ela usa verificação estática de tipos para garantir que o
valor de uma variável _sempre_ corresponda ao tipo estático da variável.
Às vezes, isso é chamado de tipagem sound.
Embora os tipos sejam obrigatórios,
as anotações de tipo são opcionais graças à inferência de tipos.
O sistema de tipos do Dart também é flexível,
permitindo o uso do tipo `dynamic` combinado com verificações em tempo de execução,
o que pode ser útil durante experimentos ou
para código que precisa ser especialmente dinâmico.

O Dart tem [sound null safety](/null-safety) integrado.
Isso significa que valores não podem ser null, a menos que você diga que podem.
Com sound null safety, o Dart pode proteger você de
exceções de null em tempo de execução por meio de análise estática de código.
Diferentemente de muitas outras linguagens com null safety,
quando o Dart determina que uma variável é non-nullable,
essa variável nunca pode ser null.
Se você inspecionar seu código em execução no debugger,
verá que a não nulidade é mantida em tempo de execução; daí o _sound_ no null safety.

O exemplo de código a seguir mostra vários recursos da linguagem Dart,
incluindo bibliotecas, chamadas assíncronas, tipos nullable e non-nullable,
sintaxe de seta, geradores, streams e getters.
Para aprender mais sobre a linguagem,
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
Este exemplo roda em um [DartPad](/tools/dartpad) embutido.
Você também pode
<a href="{{site.dartpad}}/?id=bc63d212c3252e44058ff76f34ef5730"
target="_blank" rel="noopener">abrir este exemplo em uma janela própria</a>.
:::


## Dart: as bibliotecas {:#libraries}

O Dart tem [um rico conjunto de bibliotecas principais](/libraries),
que oferecem recursos essenciais para muitas tarefas de programação do dia a dia:

* Tipos embutidos, coleções e outras funcionalidades principais para
  todo programa Dart
  (`dart:core`)
* Tipos de coleção mais ricos, como filas, listas encadeadas, hashmaps e
  árvores binárias
  (`dart:collection`)
* Encoders e decoders para converter entre diferentes representações de dados,
  incluindo JSON e UTF-8
  (`dart:convert`)
* Constantes e funções matemáticas, além de geração de números aleatórios
  (`dart:math`)
* Suporte à programação assíncrona,
  com classes como `Future` e `Stream`
  (`dart:async`)
* Listas que lidam eficientemente com dados de tamanho fixo
  (por exemplo, inteiros sem sinal de 8 bytes) e tipos numéricos SIMD
  (`dart:typed_data`)
* Suporte a arquivos, sockets, HTTP e outras operações de E/S para aplicações não web
  (`dart:io`)
* Interfaces de função externa para interoperabilidade com
  outro código que apresenta uma interface no estilo C
  (`dart:ffi`)
* Programação concorrente usando _isolates_: workers independentes
  semelhantes a threads, mas que não compartilham memória e se comunicam apenas por mensagens
  (`dart:isolate`)
* Elementos HTML e outros recursos para aplicações web que precisam
  interagir com o navegador e com o Document Object Model (DOM)
  (`dart:js_interop` e `package:web`)

Além das bibliotecas principais, muitas APIs são fornecidas por meio de
um conjunto abrangente de pacotes.
A equipe do Dart publica muitos pacotes complementares úteis,
como estes:

* [characters]({{site.pub-pkg}}/characters)
* [intl]({{site.pub-pkg}}/intl) 
* [http]({{site.pub-pkg}}/http)
* [crypto]({{site.pub-pkg}}/crypto)
* [markdown]({{site.pub-pkg}}/markdown)

Além disso, publicadores terceiros e a comunidade em geral
publicam milhares de pacotes, com suporte a recursos como estes:

* [XML]({{site.pub-pkg}}/xml) 
* [Integração com Windows]({{site.pub-pkg}}/win32)
* [SQLite]({{site.pub-pkg}}/sqflite_common)
* [compressão]({{site.pub-pkg}}/archive)

Para ver uma série de exemplos práticos com as bibliotecas principais do Dart,
leia a [documentação das bibliotecas principais](/libraries).
Para encontrar APIs adicionais, confira a
[página de pacotes comumente usados](/resources/useful-packages).


## Dart: as plataformas {:#platform}

A tecnologia de compilação do Dart permite executar código de diferentes maneiras:

* **Plataforma nativa**: para aplicações voltadas a dispositivos móveis e desktop,
  o Dart inclui uma VM do Dart com compilação just-in-time (JIT) e
  um compilador ahead-of-time (AOT) para gerar código de máquina.

* **Plataforma web**: para aplicações voltadas à web, o Dart pode compilar para
  fins de desenvolvimento ou produção. Seus compiladores web traduzem o Dart
  para JavaScript ou WebAssembly.

<img 
  src="/assets/img/Dart-platforms.svg" 
  width="800" 
  alt="Uma ilustração dos alvos suportados pelo Dart">

O [framework Flutter]({{site.flutter}}) é um toolkit de UI multiplataforma popular,
alimentado pela plataforma Dart, que oferece ferramentas e bibliotecas de UI para criar experiências
que rodam em iOS, Android, macOS, Windows, Linux e web.

#### Dart nativo (código de máquina JIT e AOT) {:#native-platform}

Durante o desenvolvimento, um ciclo de desenvolvimento rápido é essencial para a iteração.
A VM do Dart oferece um compilador just-in-time (JIT) com
recompilação incremental (que habilita o hot reload), coleta de métricas em tempo real
(que alimenta o [DevTools](/tools/dart-devtools)) e recursos ricos de depuração.

Quando as aplicações estão prontas para ser implantadas em produção, seja publicando
em uma loja de aplicativos ou fazendo deploy em um backend de produção, o
compilador ahead-of-time (AOT) do Dart pode compilar para código de máquina nativo ARM ou x64.
Sua aplicação compilada com AOT inicia com um tempo de inicialização curto e consistente.

O código compilado com AOT roda dentro de um runtime Dart eficiente que
impõe o sistema de tipos sound do Dart e
gerencia a memória usando alocação rápida de objetos e um
[coletor de lixo geracional](https://medium.com/flutter-io/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30).

#### Dart web (JavaScript de desenvolvimento e produção, e WebAssembly) {:#web-platform}

O Dart Web permite executar código Dart em plataformas web baseadas em
JavaScript. Com o Dart Web, você compila código Dart para JavaScript, que por sua vez
roda em um navegador, por exemplo, o [V8](https://v8.dev/) dentro do
[Chrome](https://www.google.com/chrome/).
Alternativamente, o código Dart pode ser compilado para WebAssembly.

O Dart web tem três modos de compilação:

* Um compilador JavaScript de desenvolvimento incremental, que permite um ciclo de desenvolvimento
  rápido com recompilação incremental (que habilita o hot reload).
* Um compilador JavaScript de produção otimizado, que compila código Dart para JavaScript
  rápido, compacto e pronto para deploy. Essas eficiências vêm de técnicas como
  a eliminação de código morto.
* Um compilador de produção WebAssembly (WasmGC) otimizado, que compila código Dart
  para código WebAssembly GC super rápido e pronto para deploy.

Mais informações:

* [Crie um aplicativo web com Dart](/web/get-started)
* [`dart compile js`](/tools/dart-compile#js)
* [Ferramenta `webdev`](/tools/webdev)
* [Dicas de deploy para web](/web/deployment)
* [Compilação para WebAssembly](/web/wasm)

#### O runtime do Dart {:#runtime}

Independentemente da plataforma que você usa ou de como compila seu código,
executar o código exige um runtime do Dart.
Esse runtime é responsável pelas seguintes tarefas críticas:

* Gerenciar memória:
  o Dart usa um modelo de memória gerenciada,
  em que a memória não utilizada é recuperada por um coletor de lixo (GC).

* Impor o sistema de tipos do Dart:
  embora a maioria das verificações de tipo no Dart seja estática (em tempo de compilação),
  algumas verificações de tipo são dinâmicas (em tempo de execução).
  Por exemplo, o runtime do Dart impõe verificações dinâmicas por meio dos
  [operadores de teste e conversão de tipo](/language/operators#type-test-operators).

* Gerenciar [isolates](/language/concurrency):
  o runtime do Dart controla o isolate principal (onde o código normalmente roda)
  e quaisquer outros isolates que a aplicação cria.

Nas plataformas nativas, o runtime do Dart é incluído automaticamente
em executáveis autocontidos, e faz parte da VM do Dart fornecida pelo
comando [`dart run`](/tools/dart-run).

## Aprendendo Dart {:#learning-dart}

Você tem muitas opções para aprender Dart. Estas são algumas que recomendamos:

* [Explore o Dart no navegador]({{site.dartpad}}/) com o DartPad,
  um ambiente de execução web para código Dart.
* [Complete o tutorial de Dart](/learn/tutorial), que
  cobre o básico de usar o Dart para criar aplicações de linha de comando.
* [Faça um tour pela linguagem Dart](/language),
  que mostra como usar cada um dos principais recursos do Dart.
* [Faça treinamentos online extensos][udemy],
  com especialistas em Dart.
* [Explore a documentação da API]({{site.dart-api}}), que
  descreve as bibliotecas principais do Dart.
* [Leia um livro sobre programação em Dart](/resources/books).

[udemy]: https://www.udemy.com/course/complete-dart-guide/?couponCode=NOV-20
