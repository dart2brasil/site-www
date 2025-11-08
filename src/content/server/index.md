---
ia-translate: true
title: Command-line and server apps
shortTitle: "CLI & server apps"
description: All things relating to command-line and server apps.
showToc: false
---

Esta página aponta para ferramentas e documentação
que podem te ajudar a desenvolver aplicativos de linha de comando e servidor.

<p class="centered-rows">
  <a href="/tutorials/server/get-started" class="filled-button large-button">Get started</a>
</p>


## Ferramentas {:#tools}

[DartPad](/tools/dartpad)
: Útil tanto para iniciantes quanto para especialistas,
  o DartPad permite que você experimente recursos da linguagem e APIs dart:*.

  :::note
  O DartPad **não** oferece suporte ao uso de bibliotecas VM, como `dart:io`,
  ou importação de bibliotecas de pacotes
  além dos [pacotes atualmente suportados][].
  :::

[pacotes atualmente suportados]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

[Dart SDK](/tools/sdk)
: [Instale o Dart SDK](/get-dart) para obter as bibliotecas
  principais do Dart e [ferramentas](/tools).

## Frameworks {:#frameworks}

Frameworks do lado do servidor escritos em Dart incluem:

[Serverpod](https://serverpod.dev)
: Um servidor de aplicativos escalável que suporta geração de código,
  autenticação, comunicação em tempo real, bancos de dados e caching (armazenamento em cache).

[Dart Frog](https://dart-frog.dev/)
: A fast, minimalistic backend framework for Dart.

Mais ferramentas
: A página [Ferramentas](/tools) tem links para ferramentas geralmente úteis,
  como plugins Dart para seu IDE ou editor favorito.

Para opções adicionais, veja [#pacotes de servidor no pub.dev]({{site.pub-pkg}}?q=topic%3Aserver).

## Tutoriais {:#tutorials}

Você pode achar os seguintes tutoriais úteis.

[Começar](/tutorials/server/get-started)
: Aprenda como usar o Dart SDK para desenvolver aplicativos de linha de comando e servidor.

[gRPC Quickstart](https://grpc.io/docs/languages/dart/quickstart/)
: Guia você na execução e modificação de um exemplo cliente-servidor que usa o framework gRPC.

[Escreva aplicativos de linha de comando](/tutorials/server/cmdline)
: Apresenta dart:io e o pacote args.

[Escreva servidores HTTP](/tutorials/server/httpserver)
: Apresenta o pacote shelf.

## Mais recursos {:#more-resources}

[Dart API]({{site.dart-api}})
: Referência da API para bibliotecas dart:*.

[documentação dart:io](/libraries/dart-io)
: Mostra como usar os principais recursos da biblioteca dart:io.
  Você pode usar a biblioteca dart:io em scripts de linha de comando, servidores e
  aplicativos [Flutter.]({{site.flutter}}) não-web
