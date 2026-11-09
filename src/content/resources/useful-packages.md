---
ia-translate: true
title: Pacotes comumente usados
shortTitle: Pacotes comuns
description: >-
  Alguns dos pacotes mais úteis e populares, e onde você pode aprender mais.
---

{% assign pub = site.pub %}
{% assign pubpkg = site.pub-pkg %}

Esta página lista alguns dos [pacotes](/tools/pub/packages) mais populares e úteis
que desenvolvedores Dart publicaram.
Para encontrar mais pacotes—e pesquisar também as [bibliotecas principais](/libraries)—use o
[site pub.dev.]({{pub}})

Os pacotes comumente usados se dividem em três grupos:

* [Pacotes de propósito geral](#general-purpose-packages)
* [Pacotes que expandem as bibliotecas principais do Dart](#packages-that-correspond-to-sdk-libraries)
* [Pacotes especializados](#specialized-packages)

## Pacotes de propósito geral {:#general-purpose-packages}

Use esses pacotes para uma ampla variedade de projetos.

| Pacote | Descrição | APIs comumente usadas |
|----|----|----|
| [archive][] | Codifica e decodifica vários formatos de arquivo e compressão. | Archive, ArchiveFile, TarEncoder, TarDecoder, ZipEncoder, ZipDecoder |
| [characters][] | Manipula strings para caracteres percebidos pelo usuário (clusters de grafemas Unicode). | String.characters, Characters, CharacterRange |
| [cronet_http][] | Fornece acesso ao cliente HTTP [Cronet][cronet] do Android usando a mesma interface do `package:http`. | |
| [cupertino_http][] | Fornece acesso ao [Foundation URL Loading System][furl] da Apple usando a mesma interface do `package:http`. | |
| [genkit][] | Cria aplicações full-stack com IA e fluxos de trabalho agentic. | Genkit, googleAI, anthropic |
| [http][] | Fornece um conjunto de funções e classes de alto nível para simplificar o consumo de recursos HTTP. | delete(), get(), post(), read() |
| [intl][] | Recursos de internacionalização e localização, com suporte a plurais e gêneros, formatação e análise de datas e números, e texto bidirecional. | Bidi, DateFormat, MicroMoney, TextDirection |
| [json_serializable][] | Gera código para manipulação de JSON. Para saber mais, consulte [Suporte a JSON](/libraries/serialization/json). | @JsonSerializable |
| [logging][] | Adiciona registro de mensagens à sua aplicação. | LoggerHandler, Level, LogRecord |
| [mockito][] | Cria mocks de objetos em testes. Ajuda quando você escreve testes para injeção de dependência. Use com o pacote [test][]. | Answering, Expectation, Verification |
| [path][] | Manipula diferentes tipos de caminhos. Para saber mais, consulte [Unboxing Packages: path.]({{site.news}}/2016/06/unboxing-packages-path.html) | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [shelf][] | Fornece middleware de servidor web para Dart. O Shelf facilita a criação e a composição de servidores web e de partes deles. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace][] | Analisa, inspeciona e manipula stack traces produzidos pelo Dart. Também transforma stack traces em um formato mais legível que a implementação nativa de StackTrace. Para saber mais, consulte [Unboxing Packages: stack_trace.]({{site.news}}/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [test][] | Padroniza a escrita e a execução de testes em Dart. | expect(), group(), test() |
| [yaml][] | Analisa marcação YAML. | loadYaml(), loadYamlStream() |

{:.table .table-striped .nowrap}

[archive]: {{pubpkg}}/archive
[characters]: {{pubpkg}}/characters
[cronet_http]: {{pubpkg}}/cronet_http
[cupertino_http]: {{pubpkg}}/cupertino_http
[genkit]: {{pubpkg}}/genkit
[http]: {{pubpkg}}/http
[intl]: {{pubpkg}}/intl
[json_serializable]: {{pubpkg}}/json_serializable
[logging]: {{pubpkg}}/logging
[mockito]: {{pubpkg}}/mockito
[path]: {{pubpkg}}/path
[shelf]: {{pubpkg}}/shelf
[stack_trace]: {{pubpkg}}/stack_trace
[test]: {{pubpkg}}/test
[yaml]: {{pubpkg}}/yaml
[Cronet]: {{site.android-dev}}/develop/connectivity/cronet
[furl]: {{site.apple-dev}}/documentation/foundation/url_loading_system

## Pacotes que expandem as bibliotecas principais do Dart {:#packages-that-correspond-to-sdk-libraries}

Cada um dos pacotes a seguir se baseia em uma [biblioteca principal](/libraries),
adicionando funcionalidades e preenchendo recursos ausentes:

| Pacote | Descrição | APIs comumente usadas |
|----|----|----|
| [async][] | Expande dart:async, adicionando classes utilitárias para trabalhar com computações assíncronas. Para saber mais, consulte [Unboxing Packages: async part 1][async-1], [part 2][async-2] e [part 3][async-3]. | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection][] | Expande dart:collection, adicionando funções e classes utilitárias para facilitar o trabalho com coleções. Para saber mais, consulte [Unboxing Packages: collection][collect]. | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
| [convert][] | Expande dart:convert, adicionando codificadores e decodificadores para converter entre diferentes representações de dados. Uma dessas representações é a _codificação percentual_, também conhecida como _codificação URL_. | HexDecoder, PercentDecoder |
| [io][] | Contém duas bibliotecas, ansi e io, para simplificar o trabalho com arquivos, streams padrão e processos. Use a biblioteca ansi para personalizar a saída do terminal. A biblioteca io tem APIs para lidar com processos, stdin e duplicação de arquivos. |  copyPath(), isExecutable(), ExitCode, ProcessManager, sharedStdIn |

{:.table .table-striped .nowrap}

[async]: {{pubpkg}}/async
[collection]: {{pubpkg}}/collection
[convert]: {{pubpkg}}/convert
[io]: {{pubpkg}}/io
[async-1]: {{site.news}}/2016/03/unboxing-packages-async-part-1.html
[async-2]: {{site.news}}/2016/03/unboxing-packages-async-part-2.html
[async-3]: {{site.news}}/2016/04/unboxing-packages-async-part-3.html
[collect]: {{site.news}}/2016/01/unboxing-packages-collection.html

## Pacotes especializados {:#specialized-packages}

Para encontrar pacotes especializados, como os de Flutter e de desenvolvimento web,
consulte as seções a seguir.

### Pacotes do Flutter {:#flutter-packages}

Para saber mais sobre pacotes do Flutter,
consulte [Using packages][flutterpkg] na documentação do Flutter
ou pesquise no site pub.dev por [pacotes do Flutter][fluttersearch].

[flutterpkg]: {{site.flutter-docs}}/development/packages-and-plugins/using-packages
[fluttersearch]: {{pub}}/flutter

### Pacotes web {:#web-packages}

Para saber mais sobre pacotes web,
consulte [Bibliotecas e pacotes web][webpkg]
ou pesquise no site pub.dev por [pacotes web][pkgsearch].

[webpkg]: /web/libraries
[pkgsearch]: {{pub}}/web

### Pacotes de linha de comando e de servidor {:#command-line-and-server-packages}

Para saber mais sobre pacotes de CLI ou de servidor,
veja [Bibliotecas e pacotes de linha de comando e de servidor](/server/libraries).
Ou use o site pub.dev para [pesquisar outros pacotes.]({{pub}})

### Pacotes de IA {:#ai-packages}

Para saber mais sobre como criar aplicações de IA generativa e fluxos de trabalho agentic,
consulte [Genkit Dart][genkit-docs]
ou pesquise no site pub.dev por [pacotes de IA][aisearch].

[genkit-docs]: https://genkit.dev/docs/dart/get-started/
[aisearch]: {{site.pub-pkg}}?q=topic%3Aai
