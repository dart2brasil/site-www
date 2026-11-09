---
ia-translate: true
title: "Anunciando o Dart 2 estável e a plataforma web do Dart"
description: "Marca o renascimento do Dart como uma linguagem de programação mainstream para desenvolvimento mobile e web"
publishDate: 2018-08-07
author: kevmoo
image: images/0YX3CcH4He_IIEhzx.webp
category: releases
layout: blog
---


Hoje anunciamos a disponibilidade imediata da versão estável do Dart 2, incluindo uma reescrita da plataforma web do Dart que oferece uma combinação única de produtividade, desempenho e escalabilidade.

<DashImage src="images/1xV5sN0ycM2OxY5BbGDhdmg.webp" alt="The Dart logo." />


Desenvolvedores Flutter já estão aproveitando muitos dos benefícios do Dart 2, já que o Flutter vem empacotando versões pré-lançamento do SDK do Dart 2 há vários meses. No entanto, o lançamento estável do Dart 2 é mais um marco importante rumo ao lançamento estável do Flutter, devido ao forte acoplamento entre framework e linguagem. Se você ainda não instalou o Flutter, [comece por aqui](https://flutter.io/get-started/install/).

Com o lançamento do Dart 2, desenvolvedores web agora podem aproveitar a mesma linguagem, as mesmas bibliotecas e as mesmas ferramentas, junto com diversas melhorias específicas para a web. Desenvolvedores web devem começar pela página [Get Started](https://webdev.dartlang.org/guides/get-started), com instruções para instalar as ferramentas e criar uma primeira aplicação.

## Dart: um entusiasmo crescente {:#dart-growing-excitement}

O Dart 2 marca o renascimento do Dart como uma linguagem de programação mainstream, focada em permitir um desenvolvimento rápido e ótimas experiências de usuário para aplicações mobile e web. Queremos que desenvolvedores de aplicações client-side sejam produtivos, com uma linguagem, um framework e componentes que reduzam o código repetitivo e permitam que eles se concentrem na lógica de negócios, junto com ferramentas que identificam erros cedo, possibilitam depuração poderosa e entregam código de runtime pequeno e rápido.

No último ano, o Dart teve um crescimento impressionante. Nossas próprias análises sugerem um crescimento de dez vezes no uso externo. No último trimestre, o Dart foi [uma das linguagens que mais cresceram no GitHub](https://madnight.github.io/githut/#/pull_requests/2018/2), medido pelo número de pull requests; o crescimento de perguntas no [StackOverflow](http://sotagtrends.com/?tags=[dart,perl,haskell,rust]&relative=false) também demonstra vividamente o momentum do Dart:

<DashImage src="images/0s3bqLPad7xh_nFH-.webp" alt="Graph of Dart-related Stack Overflow questions over time." />


Internamente, o Dart é uma das poucas linguagens que o Google usa para desenvolvimento de aplicações web, com milhões de linhas de código de dezenas de projetos diferentes, incluindo Google Ads, Google Shopping e nossas próprias equipes de infraestrutura interna.

Na verdade, você talvez já esteja usando Dart sem perceber: o popular pré-processador de folhas de estilo [Sass](https://sass-lang.com/) foi [reescrito em Dart](http://sass.logdown.com/posts/7045860-dart-sass-100-is-released) recentemente, para ficar mais rápido, mais portável e mais fácil de escrever. O Sass agora é distribuído como executável independente no Homebrew e no Chocolatey, e compilado para JavaScript puro no npm. O Dart facilita instalar aplicações em qualquer lugar, sem dependências externas, e se encaixar nos fluxos de trabalho tanto de quem usa Dart quanto de quem não usa.

<DashImage src="images/0YX3CcH4He_IIEhzx.webp" alt="Dart highlights a client-optimized language, rich frameworks, and flexible tooling for building native experiences across screens." />


O Dart 2 se concentra em três áreas: fortalecer e apertar a linguagem, desenvolver nosso suporte a frameworks web e mobile, e levar para o mundo externo parte das ferramentas e componentes que sustentam o uso do Dart pelo Google. O restante deste post vai explorar esses temas.

## Dart 2: uma linguagem otimizada para o client-side {:#dart-2-a-client-optimized-language}

Como [destacamos em fevereiro](/blog/announcing-dart-2-optimized-for-client-side-development), o [sistema de tipos do Dart](https://www.dartlang.org/guides/language/sound-dart) é *sólido*. Isso significa que uma grande classe de problemas é encontrada antes de os usuários executarem sua aplicação — durante a análise e a compilação. À medida que escalamos o Dart para apps extremamente grandes dentro do Google, o sistema de tipos pegou mais erros cedo no ciclo de desenvolvimento, o que levou a um código de produção de maior qualidade.

Com o Dart 2, você não consegue chegar a um estado em que uma expressão avalia para um valor que não corresponde ao tipo estático da expressão. Isso significa que você pode escalar sua base de código para milhões de linhas, enfrentar grandes projetos de refatoração e fazer o deploy do seu código com confiança.

Não se preocupe: solidez não significa montanhas de código repetitivo. O sistema de tipos inclui uma inferência avançada — até para argumentos de tipo genéricos.

```
final _field = [3.14, 6.28];

void main() {
  // No type parameter is provided, but <int> is inferred
  print([1, 2, 3].runtimeType); // List<int>

  // If types are unmatched, their common base type is used
  // int (1) and double (3.14) are both `num`
  print([1, 3.14].runtimeType); // List<num>

  // Inference goes beyond variables.
  // You can omit types on fields, too.
  print(_field.runtimeType); // List<double>
}
```


Para saber mais sobre o sistema de tipos do Dart 2, veja [esta página](https://www.dartlang.org/guides/language/sound-dart).

Como mencionado em posts anteriores, o Dart 2 também reduz o excesso de cerimônia da linguagem em algumas áreas importantes: por exemplo, a palavra-chave `new` agora é opcional, e a palavra-chave `const` é opcional dentro de um contexto constante.

Por fim, fizemos muito trabalho nos bastidores para unificar várias ferramentas de suporte, com um front-end comum que agora atende nossos compiladores e runtimes. Isso garante consistência para nossos usuários hoje e promete melhorar a velocidade e a qualidade de novos recursos à medida que o Dart continua evoluindo.

## Dart na web: um framework rico e poderoso {:#dart-on-the-web-a-rich-powerful-framework}

Aplicações web sempre foram centrais para a missão do Dart desde o início. Na verdade, a maior parte do desenvolvimento em Dart no Google é para aplicações web. Uma das maiores é o Google Ads, que movimenta bilhões de dólares da economia web. No processo de migrar o código deles para o Dart, eles reduziram o tamanho da base de código da UI em 40%, ao mesmo tempo que melhoraram a produtividade dos desenvolvedores e a qualidade da aplicação.

Embora o SDK core do Dart forneça bibliotecas para acessar APIs modernas dos navegadores, também oferecemos um framework robusto inspirado no Angular para criar aplicações web complexas. O [AngularDart 5](https://webdev.dartlang.org/angular), lançado como parte do Dart 2, aproveita o sistema de tipos sólido do Dart e o [novo sistema de build](https://github.com/dart-lang/build) (descrito abaixo) para oferecer builds incrementais rápidos durante o desenvolvimento e JavaScript compilado menor quando você estiver pronto para o deploy.

Um foco importante desta versão foi reduzir a quantidade de código processada no carregamento da página, diminuindo significativamente o ‘tempo até a interatividade’ das páginas web. Muitos apps tiveram o tamanho do código reduzido em mais da metade em comparação com o AngularDart 4.

Para demonstrar as melhorias na plataforma web do Dart, construímos uma [implementação cliente em Dart do HackerNews](https://hnpwa.dartlang.org/) como uma Progressive Web App; ela foi publicada junto com outras implementações de exemplo no popular site [HNPWA](https://hnpwa.com/). Usando as melhores práticas para construir apps web em Dart, conseguimos entregar uma experiência completa que fica totalmente interativa em um segundo em dispositivos modernos e em menos de cinco segundos em um dispositivo móvel modesto, em uma rede 3G lenta. Isso é competitivo até mesmo com frameworks web leves otimizados para apps menores.

<DashImage src="images/1Zf8U7ODhydytCsOn6_pQcw.webp" alt="Hacker News clone built with Dart." caption="[hnpwa.dartlang.org](https://hnpwa.dartlang.org/)" />


Nossos investimentos em frameworks também se estendem aos nossos [componentes core](https://pub.dartlang.org/packages/angular_components), que também foram atualizados. Agora você tem acesso a 100 novas classes, incluindo vários componentes de data, hora e menu do [Material](https://material.io/). Você pode explorar todos os nossos componentes na [galeria de componentes](https://dart-lang.github.io/angular_components_example/).

<DashImage src="images/0drInYm1m0XD2vGZS.webp" alt="Animation demonstrating the Material Date Picker component." caption="*Material Date Picker — um dos componentes ricos disponíveis para sua aplicação web*" />


## Ferramentas flexíveis para o Dart 2 {:#flexible-tooling-for-dart-2}

Com o Dart 2, o Dart se torna uma linguagem de primeira classe compilada para JavaScript, com um ciclo de desenvolvimento que desenvolvedores web esperam e um excelente desempenho em tempo de execução. Isso é feito oferecendo benefícios que a maioria das linguagens voltadas para JavaScript não oferece: um sistema de tipos sólido e excelente suporte a apps mobile nativos.

Com o Dart 2, nossas ferramentas web adotam um modelo de desenvolvimento 100% JavaScript, com dois compiladores JavaScript complementares. O compilador de desenvolvimento, [dartdevc](https://webdev.dartlang.org/tools/dartdevc), oferece compilação incremental rápida e gera JavaScript fácil de ler e depurar. Isso permite que nosso compilador de produção, o [dart2js](https://webdev.dartlang.org/tools/dart2js), se concentre em produzir JavaScript altamente otimizado para progressive web apps para mobile e experiências empresariais complexas no desktop. Os dois compiladores aproveitam o sistema de tipos sólido do Dart para otimizar a saída.

Nossas ferramentas web são baseadas em um [novo sistema de build](https://github.com/dart-lang/build), projetado para ser rápido, depurável e extensível. Agora, tarefas como gerar código de serialização, compilar Sass para CSS e compilar Dart para JavaScript acontecem em uma única cadeia de ferramentas que oferece suporte a atualizações rápidas e incrementais conforme você altera partes da sua aplicação. O sistema de build também foi projetado para suportar usos além da web. Um exemplo: ele é usado por desenvolvedores Flutter para gerar [código de serialização JSON](https://flutter.io/json/#serializing-json-using-code-generation-libraries).

Com o Dart 2, também temos um conjunto ampliado de ferramentas de desenvolvimento. Além do suporte ao [Android Studio](https://developer.android.com/studio/) e à suíte de ferramentas da JetBrains, incluindo o [IntelliJ IDEA](https://www.jetbrains.com/idea/) e o [WebStorm](https://www.jetbrains.com/webstorm/), também oferecemos suporte ao [Visual Studio Code](https://code.visualstudio.com/) com a [extensão Dart Code](https://dartcode.org/). E também temos um ótimo bloco de rascunho para experimentar: o [DartPad](https://dartpad.dartlang.org/), totalmente atualizado para o Dart 2.

Por fim, o SDK do Dart vem com um conjunto de outras ferramentas úteis: um gerenciador de pacotes que funciona com o nosso [site de pacotes](https://pub.dartlang.org/), um [analisador estático](https://www.dartlang.org/tools/analyzer), um linter que você pode usar pela linha de comando ou como pacote, e ferramentas para [documentação web](https://pub.dartlang.org/packages/dartdoc) e [formatação de código](https://pub.dartlang.org/packages/dart_style) que seguem o [guia de estilo do Dart](https://www.dartlang.org/guides/language/effective-dart/style).

## Saiba mais {:#learn-more}

Confira as instruções para começar com o [Flutter](https://flutter.io/get-started/install/) e o [conjunto de ferramentas web do Dart](https://webdev.dartlang.org/guides/get-started).

As [notas de release](https://groups.google.com/a/dartlang.org/forum/#!topic/announce/IUWWXwL7QB4) trazem um detalhamento técnico das inúmeras outras melhorias menores feitas desde o Dart 1, algumas das quais são mudanças incompatíveis para código Dart mais antigo. Se você encontrar problemas que uma busca no Google não resolva, recomendamos começar pelo [StackOverflow](https://stackoverflow.com/questions/tagged/dart). Assine a lista de e-mails [Dart Announcements](https://groups.google.com/a/dartlang.org/forum/#!forum/announce) e [siga-nos no Twitter](https://twitter.com/dart_lang) para receber atualizações. Também adoraríamos ver você em nossas comunidades, como a sala de chat no [Gitter](https://gitter.im/dart-lang/home) e o [subreddit r/dartlang](https://www.reddit.com/r/dartlang/).

## Obrigado {:#thank-you}

O Dart se tornou uma linguagem de propósito geral otimizada para o desenvolvimento web e mobile. Trabalhamos no Dart 2 por vários anos, durante os quais ele tocou todos os aspectos do nosso ecossistema e exigiu a migração de milhões de linhas de código e centenas de pacotes.

Somos gratos às comunidades [Dart](https://www.dartlang.org/) e [Flutter](https://flutter.io/), assim como às centenas de engenheiros do Google que nos ajudaram nessa jornada. Não teríamos conseguido sem vocês!
