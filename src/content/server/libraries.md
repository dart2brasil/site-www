---
ia-translate: true
title: Bibliotecas e pacotes de linha de comando e servidor
shortTitle: Bibliotecas CLI e servidor
description: >-
  Bibliotecas e pacotes que podem ajudar você
  a escrever aplicativos de linha de comando e servidor em Dart.
---

O [Dart SDK][] contém [dart:io][] e outras bibliotecas
que fornecem APIs de baixo nível para linha de comando e servidor.

[Dart SDK]: /tools/sdk
[dart:io]: {{site.dart-api}}/dart-io/dart-io-library.html

## Bibliotecas do SDK {:#sdk-libraries}

O Dart SDK contém dart:io e outras bibliotecas
que fornecem APIs de baixo nível para web.

[A documentação do dart:io](/libraries/dart-io)
: Um tour com exemplos de uso da biblioteca dart:io.
  Os tópicos incluem trabalhar com arquivos e diretórios, e fazer e tratar
  requisições HTTP.

[Referência da API dart:io][dart:io]
: Documentação de referência completa da biblioteca dart:io.


## Pacotes da comunidade {:#community-packages}

O [site pub.dev]({{site.pub}}) permite buscar pacotes
que oferecem suporte a aplicativos de linha de comando e de servidor,
especificando as plataformas que seu aplicativo precisa suportar.
Você também pode buscar palavras que descrevam a funcionalidade de que precisa.

### Pacotes de linha de comando {:#command-line-packages}

Aplicativos de linha de comando costumam usar os seguintes pacotes,
além de [pacotes de propósito geral][general-purpose packages] como `archive`, `intl` e `yaml`:


| **Pacote**                                | **Descrição**                                                                           |
|-------------------------------------------|-----------------------------------------------------------------------------------------|
| [args]({{site.pub-pkg}}/args)             | Analisa argumentos brutos de linha de comando em um conjunto de opções e valores.       |
| [cli_util]({{site.pub-pkg}}/cli_util)     | Fornece utilitários para criar aplicativos de linha de comando.                         |
| [completion]({{site.pub-pkg}}/completion) | Adiciona autocompletar de linha de comando a aplicativos que usam o pacote `args`.      |
| [path]({{site.pub-pkg}}/path)             | Fornece operações abrangentes e multiplataforma para manipular caminhos.                |
| [usage]({{site.pub-pkg}}/usage)           | Encapsula o Google Analytics.                                                           |

{:.table .table-striped .nowrap}

### Pacotes de servidor {:#server-packages}

Aplicativos de servidor podem escolher entre muitos pacotes, além dos
pacotes listados na tabela anterior
e dos [pacotes de propósito geral][general-purpose packages], como `logging`:

| **Pacote**                                                | **Descrição**                                                                                                                           |
|-----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| [crypto]({{site.pub-pkg}}/crypto)                         | Implementa funções de hash criptográfico para algoritmos como SHA-1, SHA-256, MD5 e HMAC.                                               |
| [dart_frog]({{site.pub-pkg}}/dart_frog)                   | Um framework de backend rápido e minimalista para Dart, construído sobre o Shelf.                                                       |
| [firebase_admin_sdk]({{site.pub-pkg}}/firebase_admin_sdk) | Acessa serviços do Firebase, como Cloud Firestore e Firebase Authentication, de forma segura no servidor.                               |
| [firebase_functions]({{site.pub-pkg}}/firebase_functions) | Escreve funções e APIs de backend sem servidor para Cloud Functions for Firebase.                                                       |
| [genkit]({{site.pub-pkg}}/genkit)                         | Cria aplicações full-stack com IA, fluxos e fluxos de trabalho agênticos.                                                               |
| [grpc]({{site.pub-pkg}}/grpc)                             | Implementa [gRPC][], um framework RPC de código aberto e alta performance, que prioriza mobile e HTTP/2.                                |
| [serverpod]({{site.pub-pkg}}/serverpod)                   | Um servidor de aplicação escalável que suporta geração de código, autenticação, comunicação em tempo real, bancos de dados e caching.   |
| [shelf]({{site.pub-pkg}}/shelf)                           | Fornece um modelo para middleware de servidor web que incentiva composição e reutilização fácil.                                        |

{:.table .table-striped .nowrap}

[general-purpose packages]: /resources/useful-packages#general-purpose-packages
[gRPC]: https://grpc.io/
