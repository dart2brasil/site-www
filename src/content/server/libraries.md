---
title: Command-line and server libraries and packages
shortTitle: CLI & server libraries
description: "Libraries and packages that can help you write Dart command-line & server apps."
---

O [Dart SDK][] contém [dart:io][] e outras bibliotecas
que fornecem APIs de linha de comando e servidor de baixo nível.

[Dart SDK]: /tools/sdk
[dart:io]: {{site.dart-api}}/dart-io/dart-io-library.html

## Bibliotecas do SDK {:#sdk-libraries}

O Dart SDK contém dart:io e outras bibliotecas
que fornecem APIs web de baixo nível.

[A documentação dart:io](/libraries/dart-io)
: Um tour baseado em exemplos de como usar a biblioteca dart:io.
  Os tópicos incluem trabalhar com arquivos e diretórios e fazer e lidar com
  requisições HTTP.

[Referência da API dart:io][dart:io]
: Documentação de referência completa para a biblioteca dart:io.


## Pacotes da comunidade {:#community-packages}

O site [pub.dev]({{site.pub}}) permite que você pesquise pacotes
que suportam aplicativos de linha de comando e servidor
especificando as plataformas que seu aplicativo precisa suportar.
Você também pode pesquisar palavras que descrevam a funcionalidade que você precisa.

### Pacotes de linha de comando {:#command-line-packages}

Aplicativos de linha de comando geralmente usam os seguintes pacotes,
além de [pacotes de uso geral][] como `archive`, `intl` e `yaml`:


| **Pacote**                             | **Descrição**                                                              |
|----------------------------------------|----------------------------------------------------------------------------|
| [args]({{site.pub-pkg}}/args)          | Analisa argumentos brutos de linha de comando em um conjunto de opções e valores. |
| [cli_util]({{site.pub-pkg}}/cli_util)  | Fornece utilitários para construir aplicativos de linha de comando.        |
| [completion]({{site.pub-pkg}}/completion) | Adiciona preenchimento de linha de comando para aplicativos que usam o pacote `args`. |
| [path]({{site.pub-pkg}}/path)          | Fornece operações abrangentes e multiplataforma para manipular caminhos (paths).|
| [usage]({{site.pub-pkg}}/usage)        | Envolve o Google Analytics.                                                |

{:.table .table-striped .nowrap}

### Pacotes de servidor {:#server-packages}

Aplicativos de servidor podem escolher entre muitos pacotes, além de
pacotes listados na tabela anterior
e [pacotes de uso geral][] como `logging`:

| **Pacote**                             | **Descrição**                                                                                                        |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| [crypto]({{site.pub-pkg}}/crypto)       | Implementa funções de hash criptográficas para algoritmos como SHA-1, SHA-256, MD5 e HMAC.                           |
| [grpc]({{site.pub-pkg}}/grpc)           | Implementa [gRPC][], um framework RPC geral de alto desempenho, de código aberto, que prioriza mobile e HTTP/2.      |
| [shelf]({{site.pub-pkg}}/shelf)         | Fornece um modelo para middleware de servidor web que incentiva a composição e fácil reutilização.                     |
| [dart_frog]({{site.pub-pkg}}/dart_frog) | Um framework backend rápido e minimalista para Dart construído sobre o Shelf.                                       |
| [serverpod]({{site.pub-pkg}}/serverpod) | Um servidor de aplicativos escalável que suporta geração de código, autenticação, comunicação em tempo real, bancos de dados e cache. |

{:.table .table-striped .nowrap}

[pacotes de uso geral]: /resources/useful-packages#general-purpose-packages
[gRPC]: https://grpc.io/
