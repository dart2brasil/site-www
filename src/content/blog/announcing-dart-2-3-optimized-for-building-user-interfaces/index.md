---
ia-translate: true
title: "Anunciando o Dart 2.3: otimizado para construir interfaces de usuário"
description: "Hoje anunciamos o lançamento stable do SDK do Dart 2.3, com novos recursos de linguagem que melhoram sua experiência de código ao desenvolver interfaces de usuário…"
publishDate: 2019-05-08
author: mit-mit
image: images/0iKWVPoE5aSiCI-mW.webp
category: releases
layout: blog
---


Hoje anunciamos o lançamento stable do SDK do Dart 2.3, com novos recursos de linguagem que melhoram a sua experiência de código ao desenvolver interfaces de usuário, novo suporte de ferramentas para desenvolver a UI do Flutter e dois novos sites: [dart.dev](https://dart.dev) e [pub.dev](https://pub.dev).

<DashImage src="images/0iKWVPoE5aSiCI-mW.webp" alt="Dart 2.3 release banner highlighting UI language support, IDE support, and the new dart.dev and pub.dev websites." />


## O momentum do Dart {:#darts-momentum}

Um dos relatórios de pesquisa com desenvolvedores que aguardamos todo ano é a [Pesquisa de Desenvolvedores do StackOverflow](https://insights.stackoverflow.com/survey/2019), que oferece um conjunto de dados abrangente sobre tendências entre desenvolvedores e a percepção sobre diferentes tecnologias. A edição deste ano demonstrou o crescimento da popularidade e do conhecimento sobre o Dart, que entrou pela primeira vez na lista de [Linguagens Mais Amadas](https://insights.stackoverflow.com/survey/2019#technology-_-most-loved-dreaded-and-wanted-languages) e ficou ao lado de outras linguagens populares, como JavaScript, C# e Go, e à frente de C++, F# e R. Ao mesmo tempo, nossos bons amigos da comunidade Flutter ficaram em terceiro lugar na lista de [Frameworks Mais Amados](https://insights.stackoverflow.com/survey/2019#technology-_-most-loved-dreaded-and-wanted-other-frameworks-libraries-and-tools). A pesquisa da Codementor do mês passado sobre *quais linguagens de programação aprender e quais não aprender* trouxe notícias igualmente positivas:.
> *“*Dois exemplos de linguagens que realmente se destacaram no título de Mais Melhoradas são Dart e Ruby*”.* Codementor, abril de 2019 [[fonte](https://www.codementor.io/blog/worst-languages-2019-6mvbfg3w9x)]

Gostaríamos de deixar um grande *obrigado* a todos os desenvolvedores da comunidade Dart. Significa muito para nós ver você adotar o Dart, oferecer seu feedback e continuar a jornada conosco enquanto tentamos construir a melhor linguagem otimizada para o cliente, para aplicações rápidas que rodam em qualquer plataforma.

## Novos recursos de linguagem para construir interfaces de usuário {:#new-language-features-for-building-user-interfaces}

Falando em desenvolvimento para o cliente, um dos projetos conjuntos de longa data das equipes do Dart e do Flutter é criar um ótimo suporte para escrever o código da interface de usuário em Dart, sem precisar de uma linguagem de marcação. Acreditamos que usar uma única linguagem tanto para o comportamento quanto para o layout traz grandes benefícios. Entre eles, reduzir a troca de contexto, não precisar aprender duas linguagens e permitir que todos os recursos de abstração de uma linguagem de propósito geral sejam usados ao construir a sua UI.

Fizemos várias melhorias nas últimas versões, como simplificar o código para [construir widgets](/blog/announcing-dart-2-optimized-for-client-side-development#ui-as-code), adicionar a [conversão automática de int para double](/blog/announcing-dart-2-1-improved-performance-usability) e adicionar [set literals](/blog/announcing-dart-2-2-faster-native-code-support-for-set-literals). No Dart 2.3, damos mais um grande passo à frente, com três novos recursos para expressar UIs baseadas em listas, condicionais ou repetidas.

Você pode pensar em uma UI como uma árvore de nós de widgets. Alguns nós contêm listas de widgets, por exemplo, uma lista de elementos roláveis. Frequentemente, essas listas são construídas a partir de outras listas. Para isso, adicionamos um novo recurso de [*spread operator*](https://dart.dev/guides/language/language-tour#spread-operator) para *desempacotar* os elementos de uma lista dentro de outra. No exemplo a seguir, `buildMainElements()` retorna uma lista de widgets, que é desempacotada na lista externa usando o operador spread `…`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```


Outra tarefa comum na UI é incluir um elemento específico com base em uma condição. Por exemplo, você pode querer incluir um botão *Próximo* em todas as páginas, exceto na última. Com o Dart 2.3, você pode fazer isso usando um [*collection if*](https://dart.dev/guides/language/language-tour#collection-operators):

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```


Por fim, UIs frequentemente constroem elementos repetidos a partir de outros elementos repetidos. Você pode expressar isso com o novo recurso [*collection for*](https://dart.dev/guides/language/language-tour#collection-operators):

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    for (var section in sections)
      HeadingAction(section.heading),
  ]);
}
```


E, como os três novos recursos são recursos de linguagem, e não comandos de marcação, eles são totalmente combináveis e podem ser usados em qualquer contexto em que você trabalhe com coleções. Os recursos estão incluídos na versão [Flutter 1.5](https://medium.com/flutter-io/announcing-flutter-1-5-d203c6072e5c) e disponíveis na versão [Dart 2.3](https://dart.dev/get-dart), que você pode baixar hoje. Também adicionamos novos lints que você pode [configurar na análise estática](https://dart.dev/guides/language/analysis-options#enabling-linter-rules) para impor o uso dos novos recursos de [spread](http://dart-lang.github.io/linter/lints/prefer_spread_collections.html), [collection if](http://dart-lang.github.io/linter/lints/prefer_if_elements_to_conditional_expressions.html) e [collection for](http://dart-lang.github.io/linter/lints/prefer_for_elements_to_map_fromIterable.html).

Para detalhes sobre todo o trabalho realizado para adicionar esses recursos, confira [este post recente](/blog/making-dart-a-better-language-for-ui) de Bob Nystrom (também conhecido como [munificentbob](https://twitter.com/munificentbob)), engenheiro da equipe de linguagem do Dart.

Também gostaríamos de agradecer aos desenvolvedores que participaram dos estudos de UX, que foram fundamentais para moldar esses novos recursos de linguagem.

## Recursos de IDE e editor {:#ide-editor-features}

Em linha com o tema de UI do Dart 2.3, também adicionamos um novo recurso de UI Guides ao nosso suporte de IDE. UI Guides são linhas horizontais e verticais desenhadas dentro do código de UI, o que torna muito mais fácil ver a estrutura em árvore dos métodos `build()` de UI do Flutter. Aqui está um exemplo (de um app Calculator) em que os UI Guides mostram claramente que a UI é construída a partir de uma Column expandida que contém várias KeyRows, cada uma com NumberKeys.

<DashImage src="images/1CsGJu4iSvHzspALjfbQRfA.webp" alt="IDE with Flutter UI Guides visualizing the tree structure of UI code." caption="IDE with UI Guides visualizing the tree structure of UI code" />


Os UI Guides estão disponíveis na [versão 35.2](https://plugins.jetbrains.com/plugin/9212-flutter) do plugin para IntelliJ IDEA e Android Studio. Para ativar o recurso, escolha a configuração *Preferences &gt; Languages & Frameworks &gt; Flutter &gt; UI Guides*. Esperamos oferecer um suporte semelhante no VS Code em uma versão futura.

Por fim, observamos que os desenvolvedores costumam usar o autocompletar do IDE como forma de explorar APIs. O autocompletar funcionava bem para explorar as APIs das bibliotecas que você já importou, mas não estava disponível para APIs de bibliotecas que ainda não foram importadas. Nossas ferramentas agora conseguem suportar esse último caso de uso: você pode invocar o autocompletar em qualquer prefixo e verá sugestões para todas as APIs do pacote atual, dos pacotes dos quais ele depende diretamente e do SDK. Se você escolher uma sugestão de uma biblioteca ainda não importada (marcada como *Auto import*, como mostra a animação a seguir), a ferramenta adiciona a instrução de import para você.

<DashImage src="images/0fqBkEGgVtWMT1QRy.webp" alt="An animated GIF showing code completion and automatic import insertion in an IDE." caption="Animation showing code completion & automatic import adding" />


Esse novo recurso de importação automática está disponível no VS Code com o [plugin v2.26](https://dartcode.org/releases/v2-26/), no IntelliJ 2019.1 e na próxima versão do Android Studio 3.5.

## Novos sites do Dart e do Pub {:#new-dart-pub-websites}

Por último, mas certamente não menos importante, estivemos bastante ocupados nos últimos meses construindo um novo site para a plataforma Dart: [dart.dev](https://dart.dev)

<DashImage src="images/1ydTSALWV77UbB3WHKsy9cg.webp" alt="Redesigned dart.dev homepage." caption="Redesigned [https://dart.dev](https://dart.dev) homepage" />


Este novo site traz uma página inicial totalmente nova, focada em explicar os principais benefícios da plataforma Dart. Também atualizamos as páginas de documentação para ter uma navegação melhor e mais apelo visual. Por fim, fizemos uma grande reorganização de todo o conteúdo para facilitar a descoberta e adicionamos novas páginas para conteúdos essenciais que antes não existiam.

Na mesma linha, atualizamos visualmente o site de pacotes do Pub e o movemos para uma URL mais prática: [pub.dev](https://pub.dev).

Adoraríamos ouvir o seu feedback sobre os dois sites. Se você encontrar um problema ou tiver uma sugestão, crie uma issue no [issue tracker do dart.dev](https://github.com/dart-lang/site-www/issues) ou no [issue tracker do pub.dev](https://github.com/dart-lang/pub-dartlang-dart/issues). Obrigado pelo seu apoio!
