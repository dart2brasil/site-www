---
ia-translate: true
title: "Um DartPad.dev totalmente novo, com suporte a Flutter"
description: "Hoje estamos anunciando uma grande atualização do DartPad.dev, com visual novo e suporte ao popular toolkit de UI Flutter."
publishDate: 2019-12-04
author: johnpryan
image: images/1X7Sild_wdEFGRYaSk2C3Og.webp
category: announcements
layout: blog
---


Hoje estamos anunciando uma grande atualização do [DartPad.dev](https://dartpad.dev), com visual novo e suporte ao popular toolkit de UI [Flutter](https://flutter.dev/). O DartPad é o nosso editor online que executa programas Dart direto no seu navegador, e agora ele também executa aplicativos Flutter.

<DashImage src="images/1X7Sild_wdEFGRYaSk2C3Og.webp" alt="A interface do DartPad executando um aplicativo Flutter." />


## Crie algo hoje mesmo {:#make-something-today}

Para criar um novo projeto Flutter, clique no botão **New Pad** e escolha **Flutter**.

<DashImage src="images/1Sd404nMeJmYEgbPpE7HN7g.webp" alt="Uma animação mostrando como criar um novo projeto Flutter no DartPad." />


Isso adiciona um código inicial ao editor e o executa. Sempre que o DartPad percebe que você está usando `package:flutter`, aparece um painel para exibir a UI. Você também pode usar o menu **Samples** para encontrar um exemplo de Flutter.

<DashImage src="images/1CONdjdCgZJH6oN7B4tjA5w.webp" alt="O menu de exemplos do DartPad exibindo vários exemplos de Dart e Flutter." />


## Recursos {:#features}

Todas as bibliotecas principais do Flutter, como [cupertino](https://api.flutter.dev/flutter/cupertino/cupertino-library.html) e [material](https://api.flutter.dev/flutter/material/material-library.html), estão disponíveis para uso, e o DartPad consegue exibir a documentação delas. Selecione um símbolo para ver a documentação no painel inferior.

<DashImage src="images/1pjBKPqejQhVga2yXYWWigw.webp" alt="Uma animação mostrando a documentação do widget AppBar exibida no painel inferior do DartPad." />


O DartPad formata o código usando o formatador do Dart ([dartfmt](https://github.com/dart-lang/dart_style)), oferece assists, fornece correções, sugere autocompletar e mostra erros e avisos.

<DashImage src="images/1f-DNPnkA6gB5wkT_TVVpSQ.webp" alt="Uma animação do suporte do DartPad a autocompletar e assists de código." />


Quando quiser compartilhar seu snippet, você pode [criar um gist no GitHub](https://help.github.com/en/github/writing-on-github/creating-gists) e colocar o ID do gist em uma URL assim: `https://dartpad.dev/&lt;GistID&gt;`. Você pode compartilhar esse link em um relatório de bug, em uma pergunta no StackOverflow ou na rede social da sua preferência. Confira o [guia de compartilhamento](https://github.com/dart-lang/dart-pad/wiki/Sharing-Guide) para mais detalhes.

Você também pode incorporar o DartPad em uma página, [como neste codelab](https://flutter.dev/docs/codelabs/layout-basics). DartPads incorporados são especialmente bons para artigos, codelabs e tutoriais. (Confira [este guia](https://dart.dev/resources/dartpad-tutorials.pdf) se tiver interesse em usar o DartPad em codelabs e tutoriais.) Para saber mais sobre como adicionar o DartPad a uma página, confira o [guia de incorporação](https://github.com/dart-lang/dart-pad/wiki/Embedding-Guide).

## Obrigado! {:#thanks}

O DartPad faz parte do [projeto open source](https://github.com/dart-lang) do Dart. Se você abriu [issues](https://github.com/dart-lang/dart-pad/issues) ou enviou mudanças para o DartPad, obrigado por torná-lo melhor. Se quiser contribuir, comece em [github.com/dart-lang/dart-pad](https://github.com/dart-lang/dart-pad). Para saber mais sobre como executar Flutter na web, visite [flutter.dev/web](https://flutter.dev/web).

Mal podemos esperar para ver o que você vai construir!
