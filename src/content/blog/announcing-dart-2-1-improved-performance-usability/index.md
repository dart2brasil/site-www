---
ia-translate: true
title: "Anunciando o Dart 2.1: melhor desempenho e usabilidade"
description: "Hoje estamos anunciando o lançamento estável do Dart 2.1, uma atualização do Dart 2 com novos recursos de linguagem e melhorias de desempenho"
publishDate: 2018-11-15
author: mit-mit
image: images/1xZHP-8eEl6qJCCTKXyQZ8w.webp
category: releases
layout: blog
---


Hoje estamos anunciando o lançamento estável do Dart 2.1, uma atualização do Dart 2 que traz código menor, verificações de tipo mais rápidas, melhor usabilidade nos erros de tipo e novos recursos de linguagem para aumentar a produtividade na criação de experiências de usuário.

<DashImage src="images/1xZHP-8eEl6qJCCTKXyQZ8w.webp" alt="Banner de lançamento do Dart 2.1 listando ferramentas mais rápidas, saída menor, verificação de tipos em tempo de compilação, inferência de int para double e nova sintaxe de mixin." />


## Consolidando o Dart 2 {:#landing-dart-2}

O Dart 2 foi uma grande atualização da plataforma Dart. Ele completou a transformação das nossas origens na web para uma linguagem de programação mainstream, adequada ao desenvolvimento rápido de experiências de usuário ricas em mobile e web. O Dart é um tanto único como linguagem por oferecer tanto uma máquina virtual (VM) quanto compilação para código de máquina nativo e para JavaScript. Isso atende às diferentes necessidades das várias plataformas, tanto em desenvolvimento quanto em produção.

Como parte da transição para o Dart 2, adicionamos um [sistema de tipos sound](https://www.dartlang.org/guides/language/sound-dart) para apoiar equipes grandes que constroem apps complexos, suporte novo no compilador para gerar código nativo otimizado para dispositivos móveis e [ferramentas da plataforma web](https://webdev.dartlang.org/tools) completamente reformuladas. O Dart dá vida ao [Flutter](https://flutter.io), nosso toolkit em rápido crescimento para construir experiências nativas bonitas para iOS e Android a partir de uma única base de código; ele também é a linguagem usada por alguns dos maiores projetos do Google, como o Google Ads.

Desde o [lançamento do Dart 2](/blog/announcing-dart-2-stable-and-the-dart-web-platform) em agosto, trabalhamos para levar todo o ecossistema para o Dart 2. Passamos a usar exemplos de Dart 2 em todo o nosso site [dartlang.org](https://www.dartlang.org/) e oferecemos [ferramentas e documentação para migrar](/blog/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site) pacotes Dart 1.x. Entendemos que as grandes mudanças do Dart 2 exigiram trabalho de migração dos desenvolvedores Dart existentes, e somos muito gratos a quem nos ajudou a construir uma nova base para o futuro. Agora nosso foco passa a ser aproveitar esses investimentos para entregar melhorias de desempenho e produtividade.

## Suporte da linguagem à conversão de int para double no Dart 2.1 {:#dart-2-1-language-support-for-int-to-double-conversion}

Desenvolvedores Flutter iniciantes muitas vezes tropeçam em erros de análise como estes ao especificar padding, definir tamanhos de fonte etc.:

<DashImage src="images/19hItMsF9iM2BHzbuJkHNbg.webp" alt="Código mostrando valores inteiros passados para EdgeInsets.symmetric, com erros de análise porque a API espera doubles." />


Do ponto de vista do sistema, esses erros fazem sentido: a API espera um tipo (um double) e o desenvolvedor especifica um valor de outro tipo (um int). Mas, do ponto de vista da usabilidade, parece meio bobo: existe uma conversão trivial de int para double, então por que não fazer isso? O Dart 2.1 agora [infere onde um int pode ser avaliado silenciosamente como double](https://github.com/dart-lang/language/issues/4):

<DashImage src="images/1bJV4DQzBey1fc64nerTprg.webp" alt="Código mostrando EdgeInsets.symmetric com valores inteiros aceitos para o padding horizontal e vertical." />


## Suporte da linguagem a mixins no Dart 2.1 {:#dart-2-1-language-support-for-mixins}

Também [melhoramos o suporte do Dart a mixins](https://github.com/dart-lang/language/issues/7). Se você ainda não conhece os mixins do Dart, vale a pena ler esta ótima [introdução aos mixins do Dart](https://medium.com/flutter-community/dart-what-are-mixins-3a72344011f3) de Romain Rastel. O Dart 2.1 introduz uma nova sintaxe para mixins, com uma nova palavra-chave `mixin` que você pode usar para definir classes que só podem ser usadas como mixins. Também adicionamos suporte para que mixins possam estender outras classes (antes eles só podiam estender `Object`) e possam invocar métodos da superclasse.

Um exemplo de extensão de classes que não são Object vem das [APIs de animação](https://flutter.io/tutorials/animation/#rendering-animations) do Flutter, em que o `SingleTickerProviderStateMixin` (uma classe do framework que fornece um ticker para avançar uma animação um único frame) [declara um mixin](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/ticker_provider.dart#L66) que implementa a interface geral TickerProvider. Animações só se aplicam a stateful widgets (já que a posição na animação é considerada estado). O novo suporte a mixins nos permite expressar isso declarando que apenas classes que estendem a classe State do Flutter podem usar o mixin:

<DashImage src="images/0uUIuZJgNCevxAkZQ.webp" alt="Código declarando SingleTickerProviderStateMixin como um mixin on State que implementa TickerProvider." />


## Verificações de tipo em tempo de compilação no Dart 2.1 {:#dart-2-1-compile-time-type-checks}

O sistema de tipos sound do Dart 2 protege você durante o desenvolvimento, avisando quando você viola o contrato especificado pelos tipos. Por exemplo, digamos que você esteja criando uma classe de estado para o Flutter. Espera-se que essa classe estenda a classe `State` do framework. Uma classe `State` espera receber o `StatefulWidget` cujo estado ela guarda.

<DashImage src="images/1Y_8yHDINe7LtvmyFmCqWzw.webp" alt="Trecho de código mostrando uma classe de estado do Flutter estendendo a classe State do framework." />


Agora, se você cometer um erro de programação e, digamos, passar um descendente de `StatelessWidget` em vez de `StatefulWidget`, a informação de tipo permite que as ferramentas peguem o erro e mostrem um aviso imediatamente:

<DashImage src="images/1Ym0nqsHWlTscD140Urk0xw.webp" alt="Captura de tela da IDE mostrando um erro porque MyHomePage não estende StatefulWidget." />


Essas verificações de tipo *em tempo de edição* foram adicionadas no Dart 2.0 (pelo [Dart Analyzer](https://www.dartlang.org/tools/analyzer)). Mas existe outro lugar onde você esperaria essas verificações de tipo, que é o *tempo de compilação*, quando você faz um build de release do Flutter. Essas verificações estavam incompletas no Dart 2.0, o que podia causar problemas de usabilidade em que código-fonte com erro compilava sem produzir nenhum erro. No Dart 2.1, essas verificações estão completas, e o Analyzer e o compilador Dart contêm as mesmas verificações.

## Melhorias de desempenho no Dart 2.1 para desenvolvedores Flutter {:#dart-2-1-performance-improvements-for-flutter-developers}

O Dart 2 em geral era mais rápido que o Dart 1.x para [código compilado AOT](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf) executando na nossa VM, como os apps Flutter. Em alguns casos extremos, porém, as verificações abrangentes adicionadas pelo [novo sistema de tipos](https://www.dartlang.org/guides/language/sound-dart) causavam um overhead indesejado de 20–40%. No Dart 2.1 reduzimos bastante o custo das verificações de tipo, tanto para código compilado AOT quanto para código executado na VM com compilação JIT (just-in-time).

Um caso concreto que se beneficia disso são as nossas ferramentas de desenvolvimento (que rodam na VM). Por exemplo, a análise de código de um app grande de benchmark (baseado em várias cópias concatenadas do Flutter Gallery) levava cerca de 41 segundos; agora leva cerca de 25 segundos.

## Melhorias de desempenho no Dart 2.1 para desenvolvedores web {:#dart-2-1-performance-improvements-for-web-developers}

Também melhoramos o tamanho do código e o tempo de compilação para código Dart executado na web. Focamos no tamanho da saída do [dart2js](https://webdev.dartlang.org/tools/dart2js) e estamos vendo bons resultados, como uma [redução de 17% no tamanho da saída minificada e melhoria de 15% no tempo de compilação](https://twitter.com/kevmoo/status/1055292888626515968) em um dos nossos exemplos.

## Mudanças além do SDK principal {:#changes-beyond-the-core-sdk}

Além das mudanças no Dart SDK citadas acima, fizemos algumas mudanças empolgantes fora do SDK principal.

Protocol buffers (ou *protobuf*, para encurtar) são um mecanismo neutro de plataforma para serializar dados estruturados. Eles são usados extensivamente dentro do Google e também vêm sendo bastante adotados fora dele, por exemplo como parte do [gRPC](https://grpc.io/). O Dart agora é uma linguagem oficialmente suportada pelo protobuf, e adicionamos documentação detalhada no [site principal de protocol buffers](https://developers.google.com/protocol-buffers/), com um [tutorial](https://developers.google.com/protocol-buffers/docs/darttutorial) e documentação de [referência](https://developers.google.com/protocol-buffers/docs/reference/overview).

Talvez você já tenha ouvido falar do [knative](https://cloud.google.com/knative/), uma plataforma baseada em [Kubernetes](https://kubernetes.io/) para apoiar o build, o deploy e o gerenciamento de cargas de trabalho serverless. Recentemente investigamos o suporte para servir código Dart no knative e [criamos um pequeno exemplo](https://github.com/knative/docs/tree/master/serving/samples/helloworld-dart). Isso provavelmente é baixo nível demais para a maioria dos desenvolvedores de apps Dart, mas achamos muito empolgante do ponto de vista da plataforma e prevemos que isso será um bloco de construção essencial para ter um suporte melhor a servir código Dart no Google Cloud, por exemplo para criar backends para apps Flutter.

## Obtendo o Dart 2.1 {:#getting-dart-2-1}

O [Dart SDK 2.1](https://www.dartlang.org/tools/sdk/archive) está disponível na página inicial do Dart. Se você é desenvolvedor Flutter, o Dart 2.1 vem incluído no próximo lançamento do Flutter 1.0.

Também atualizamos o [DartPad](https://dartpad.dartlang.org/) para executar o Dart 2.1 e adicionamos exemplos de [int para double](https://dartpad.dartlang.org/e93b969fed77325db0b848a85f1cf78e) e [mixins](https://dartpad.dartlang.org/b60dc2fc7ea49acecb1fd2b57bf9be57).

## O que vem por aí {:#whats-next}

Esperamos lançar várias versões 2.x que aproveitem a base da plataforma Dart 2. Vamos basear essas versões nas necessidades dos nossos parceiros de framework e dos desenvolvedores de apps. Em 2019 esperamos investigar as seguintes áreas:

* Evolução contínua da linguagem Dart: para o Dart 2.2, estamos investigando uma série de mudanças, como refinamentos em [expressões const](https://github.com/dart-lang/language/issues/61) e suporte a um novo [literal de Set](https://github.com/dart-lang/language/issues/37). Depois do 2.2, vamos olhar o nosso suporte a strings Unicode e investigar se conseguimos oferecer uma null safety melhor.

* Mais melhorias para otimizar o Dart como linguagem para criar interfaces de usuário: o Dart 2 começou essa jornada com o novo sistema de tipos e o new opcional, o Dart 2.1 adicionou a inferência de valores int para double, e no momento estamos investigando várias melhorias possíveis, como suporte a [condicionais em listas de widgets](https://github.com/dart-lang/language/issues/78), [expandir coleções de objetos](https://github.com/dart-lang/language/issues/47) dentro de outras coleções e até, possivelmente, [eliminar a necessidade de terminar instruções](https://github.com/dart-lang/language/issues/72) com ponto e vírgula.

* Desempenho ainda melhor: vamos continuar reduzindo o tamanho e melhorando o desempenho do código Dart compilado, incluindo melhor suporte ao uso de processadores multi-core, mais redução do tamanho do código para melhorar o tempo de download e de inicialização e, possivelmente, mais controle sobre se o tamanho ou o desempenho em tempo de execução é o mais crítico.

Para saber mais sobre Dart e Flutter, adoraríamos que você participasse do [Flutter Live](https://developers.google.com/events/flutter-live/), um evento online no dia 4 de dezembro que será transmitido ao vivo pela web. Estamos animados para compartilhar mais sobre o roadmap com você lá.

Por enquanto é isso. Esperamos que você goste do Dart 2.1!
