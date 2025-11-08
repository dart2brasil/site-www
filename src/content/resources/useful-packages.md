---
ia-translate: true
title: Commonly used packages
shortTitle: Common packages
description: >-
  Alguns dos pacotes mais úteis e populares, e onde você pode aprender mais.
---

{% assign pub = site.pub %}
{% assign pubpkg = site.pub-pkg %}

Esta página lista alguns dos mais populares e úteis
[pacotes](/tools/pub/packages) que desenvolvedores Dart publicaram.
Para encontrar mais pacotes—e pesquisar [bibliotecas core](/libraries)
também—use o [site pub.dev.]({{pub}})

Pacotes de uso comum se dividem em três grupos:

* [Pacotes de propósito geral](#general-purpose-packages)
* [Pacotes que expandem as bibliotecas core do Dart](#packages-that-correspond-to-sdk-libraries)
* [Pacotes especializados](#specialized-packages)

## Pacotes de propósito geral {:#general-purpose-packages}

Use estes pacotes para uma ampla gama de projetos.

| Pacote | Descrição | APIs comumente usadas |
|----|----|----|
| [archive][] | Encodes and decodes various archive and compression formats. | Archive, ArchiveFile, TarEncoder, TarDecoder, ZipEncoder, ZipDecoder |
| [characters][] | Manipulates strings for user-perceived characters (Unicode grapheme clusters). | String.characters, Characters, CharacterRange |
| [cronet_http][] | Provides access to the Android [Cronet][cronet] HTTP client using the same interface as `package:http`. | |
| [cupertino_http][] | Provides access to Apple's [Foundation URL Loading System][furl] using the same interface as `package:http`. | |
| [http][] | Provides set of high-level functions and classes to simplify consuming HTTP resources. | delete(), get(), post(), read() |
| [intl][] | Internationalization and localization facilities, with support for plurals and genders, date and number formatting and parsing, and bidirectional text. | Bidi, DateFormat, MicroMoney, TextDirection |
| [json_serializable][] | Generates JSON manipulation code. To learn more, consult [JSON Support](/libraries/serialization/json). | @JsonSerializable |
| [logging][] | Adds message logging to your application. | LoggerHandler, Level, LogRecord |
| [mockito][] | Mocks objects in tests. Helps when you write tests for dependency injection. Use with the [test][] package. | Answering, Expectation, Verification |
| [path][] | Manipulates different types of paths. To learn more, consult [Unboxing Packages: path.]({{site.news}}/2016/06/unboxing-packages-path.html) | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [shelf][] | Provides web server middleware for Dart. Shelf makes it easy to create and compose web servers, and parts of web servers. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace][] | Parses, inspects, and manipulates stack traces that Dart produces. Also transforms stack traces into a more readable format than the native StackTrace implementation. To learn more, consult [Unboxing Packages: stack_trace.]({{site.news}}/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [test][] | Standardizes writing and running tests in Dart. | expect(), group(), test() |
| [yaml][] | Parses YAML markup. | loadYaml(), loadYamlStream() |

{:.table .table-striped .nowrap}

[archive]: {{pubpkg}}/archive
[characters]: {{pubpkg}}/characters
[cronet_http]: {{pubpkg}}/cronet_http
[cupertino_http]: {{pubpkg}}/cupertino_http
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

## Pacotes que expandem as bibliotecas core do Dart {:#packages-that-correspond-to-sdk-libraries}

Cada um dos seguintes pacotes é construído sobre uma [biblioteca core](/libraries),
adicionando funcionalidade e preenchendo recursos ausentes:

| Pacote | Descrição | APIs comumente usadas |
|----|----|----|
| [async][] | Expande o dart:async, adicionando classes de utilitário para trabalhar com computações assíncronas. Para saber mais, consulte [Unboxing Packages: async part 1][async-1], [part 2][async-2], e [part 3][async-3]. | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection][] | Expande o dart:collection, adicionando funções e classes de utilitário para facilitar o trabalho com coleções. Para saber mais, consulte [Unboxing Packages: collection][collect]. | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
| [convert][] | Expande o dart:convert, adicionando codificadores e decodificadores para converter entre diferentes representações de dados. Uma das representações de dados é a _codificação percentual_, também conhecida como _codificação de URL_. | HexDecoder, PercentDecoder |
| [io][] | Contém duas bibliotecas, ansi e io, para simplificar o trabalho com arquivos, fluxos padrão e processos. Use a biblioteca ansi para personalizar a saída do terminal. A biblioteca io tem APIs para lidar com processos, stdin e duplicação de arquivos. | copyPath(), isExecutable(), ExitCode, ProcessManager, sharedStdIn |

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

Para encontrar pacotes especializados, como pacotes para Flutter e desenvolvimento web,
consulte as seções a seguir.

### Pacotes Flutter {:#flutter-packages}

Para saber mais sobre pacotes Flutter,
consulte [Usando pacotes][flutterpkg] na documentação do Flutter
ou pesquise no site pub.dev por [pacotes Flutter][fluttersearch].

[flutterpkg]: {{site.flutter-docs}}/development/packages-and-plugins/using-packages
[fluttersearch]: {{pub}}/flutter

### Pacotes web {:#web-packages}

Para saber mais sobre pacotes web,
consulte [Bibliotecas e pacotes web][webpkg]
ou pesquise no site pub.dev por [pacotes web][pkgsearch].

[webpkg]: /web/libraries
[pkgsearch]: {{pub}}/web

### Pacotes de linha de comando e servidor {:#command-line-and-server-packages}

Para saber mais sobre pacotes CLI ou servidor,
veja [Bibliotecas e pacotes de linha de comando e servidor](/server/libraries).
Ou use o site pub.dev para [pesquisar outros pacotes.]({{pub}})
