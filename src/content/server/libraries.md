---
ia-translate: true
title: Bibliotecas e pacotes de linha de comando e servidor
shortTitle: Bibliotecas CLI e servidor
description: >-
  Bibliotecas e pacotes que podem ajudar você
  a escrever aplicações de linha de comando e servidor em Dart.
---

O [Dart SDK][] contém [dart:io][] e outras bibliotecas
que fornecem APIs de baixo nível para linha de comando e servidor.

[Dart SDK]: /tools/sdk
[dart:io]: {{site.dart-api}}/dart-io/dart-io-library.html

## Bibliotecas do SDK

O Dart SDK contém dart:io e outras bibliotecas
que fornecem APIs de baixo nível para web.

[A documentação do dart:io](/libraries/dart-io)
: Um tour com exemplos de uso da biblioteca dart:io.
  Os tópicos incluem trabalhar com arquivos e diretórios, e fazer e manipular
  requisições HTTP.

[Referência da API dart:io][dart:io]
: Documentação de referência completa para a biblioteca dart:io.


## Pacotes da comunidade

O [site pub.dev]({{site.pub}}) permite que você busque por pacotes
que suportam aplicações de linha de comando e servidor
especificando as plataformas que sua aplicação precisa suportar.
Você também pode buscar por palavras que descrevem a funcionalidade que você precisa.

### Pacotes de linha de comando

Aplicações de linha de comando frequentemente usam os seguintes pacotes,
além de [pacotes de propósito geral][general-purpose packages] como `archive`, `intl` e `yaml`:


| **Pacote**                                | **Descrição**                                                                          |
|-------------------------------------------|----------------------------------------------------------------------------------------|
| [args]({{site.pub-pkg}}/args)             | Analisa argumentos brutos de linha de comando em um conjunto de opções e valores.      |
| [cli_util]({{site.pub-pkg}}/cli_util)     | Fornece utilitários para construir aplicações de linha de comando.                    |
| [completion]({{site.pub-pkg}}/completion) | Adiciona completação de linha de comando para aplicações que usam o pacote `args`.    |
| [path]({{site.pub-pkg}}/path)             | Fornece operações abrangentes e multiplataforma para manipular caminhos.              |
| [usage]({{site.pub-pkg}}/usage)           | Encapsula o Google Analytics.                                                          |

{:.table .table-striped .nowrap}

### Pacotes de servidor

Aplicações de servidor podem escolher entre vários pacotes, além dos
pacotes listados na tabela anterior
e [pacotes de propósito geral][general-purpose packages] como `logging`:

| **Pacote**                              | **Descrição**                                                                                                                    |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [crypto]({{site.pub-pkg}}/crypto)       | Implementa funções de hash criptográfico para algoritmos como SHA-1, SHA-256, MD5 e HMAC.                                        |
| [grpc]({{site.pub-pkg}}/grpc)           | Implementa [gRPC][], um framework RPC de código aberto e alta performance que prioriza mobile e HTTP/2.                          |
| [shelf]({{site.pub-pkg}}/shelf)         | Fornece um modelo para middleware de servidor web que incentiva composição e reutilização fácil.                                |
| [dart_frog]({{site.pub-pkg}}/dart_frog) | Um framework de backend rápido e minimalista para Dart construído sobre o Shelf.                                                |
| [serverpod]({{site.pub-pkg}}/serverpod) | Um servidor de aplicação escalável que suporta geração de código, autenticação, comunicação em tempo real, bancos de dados e caching. |

{:.table .table-striped .nowrap}

[general-purpose packages]: /resources/useful-packages#general-purpose-packages
[gRPC]: https://grpc.io/
