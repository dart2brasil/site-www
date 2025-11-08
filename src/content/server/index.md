---
ia-translate: true
title: Aplicativos de linha de comando e servidor
shortTitle: Aplicativos CLI e servidor
description: Tudo relacionado a aplicativos de linha de comando e servidor.
showToc: false
---

Esta página aponta para ferramentas e documentação
que podem ajudá-lo a desenvolver aplicativos de linha de comando e servidor.

<p class="centered-rows">
  <a href="/tutorials/server/get-started" class="filled-button large-button">Primeiros passos</a>
</p>


## Ferramentas

[DartPad](/tools/dartpad)
: Útil tanto para iniciantes quanto para especialistas,
  o DartPad permite que você experimente recursos da linguagem e APIs dart:*.

  :::note
  O DartPad **não** suporta o uso de bibliotecas VM, como `dart:io`,
  ou importação de bibliotecas de pacotes
  além dos [pacotes atualmente suportados][currently supported packages].
  :::

[currently supported packages]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

[Dart SDK](/tools/sdk)
: [Instale o Dart SDK](/get-dart) para obter as bibliotecas principais do Dart
  e as [ferramentas](/tools).

## Frameworks

Frameworks do lado do servidor escritos em Dart incluem:

[Serverpod](https://serverpod.dev)
: Um servidor de aplicativos escalável que suporta geração de código,
  autenticação, comunicação em tempo real, bancos de dados e caching.

[Dart Frog](https://dart-frog.dev/)
: Um framework de backend rápido e minimalista para Dart.

Mais ferramentas
: A página de [Ferramentas](/tools) contém links para ferramentas geralmente úteis,
  como plugins Dart para seu IDE ou editor favorito.

Para opções adicionais, consulte [pacotes #server no pub.dev]({{site.pub-pkg}}?q=topic%3Aserver).

## Tutoriais

Você pode achar os seguintes tutoriais úteis.

[Primeiros passos](/tutorials/server/get-started)
: Aprenda como usar o Dart SDK para desenvolver aplicativos de linha de comando e servidor.

[Início rápido gRPC](https://grpc.io/docs/languages/dart/quickstart/)
: Orienta você na execução e modificação de um exemplo cliente-servidor que usa o framework gRPC.

[Escreva aplicativos de linha de comando](/tutorials/server/cmdline)
: Apresenta dart:io e o pacote args.

[Escreva servidores HTTP](/tutorials/server/httpserver)
: Apresenta o pacote shelf.

## Mais recursos

[API Dart]({{site.dart-api}})
: Referência da API para bibliotecas dart:*.

[Documentação dart:io](/libraries/dart-io)
: Mostra como usar os principais recursos da biblioteca dart:io.
  Você pode usar a biblioteca dart:io em scripts de linha de comando, servidores e
  [aplicativos Flutter]({{site.flutter}}) não-web.
