---
ia-translate: true
title: Pacotes de uso comum
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
| [archive][] | Codifica e decodifica vários formatos de arquivo e compressão. | Archive, ArchiveFile, TarEncoder, TarDecoder, ZipEncoder, ZipDecoder |
| [characters][] | Manipula strings para caracteres percebidos pelo usuário (clusters de grafemas Unicode). | String.characters, Characters, CharacterRange |
| [cronet_http][] | Fornece acesso ao cliente HTTP [Cronet][] do Android usando a mesma interface do `package:http`. | |
| [cupertino_http][] | Fornece acesso ao [Sistema de Carregamento de URL da Foundation][furl] da Apple usando a mesma interface do `package:http`. | |
| [http][] | Fornece um conjunto de funções e classes de alto nível para simplificar o consumo de recursos HTTP. | delete(), get(), post(), read() |
| [intl][] | Recursos de internacionalização e localização, com suporte para plurais e gêneros, formatação e análise de data e número e texto bidirecional. | Bidi, DateFormat, MicroMoney, TextDirection |
| [json_serializable][] | Gera código de manipulação JSON. Para saber mais, consulte [Suporte a JSON](/libraries/serialization/json). | @JsonSerializable |
| [logging][] | Adiciona registro de mensagens ao seu aplicativo. | LoggerHandler, Level, LogRecord |
| [mockito][] | Simula objetos em testes. Ajuda quando você escreve testes para injeção de dependência. Use com o pacote [test][]. | Answering, Expectation, Verification |
| [path][] | Manipula diferentes tipos de caminhos. Para saber mais, consulte [Desempacotando Packages: path.]({{site.news}}/2016/06/unboxing-packages-path.html) | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [quiver][] | Simplifica o uso de bibliotecas Dart principais. Algumas das bibliotecas onde Quiver oferece suporte adicional incluem async, cache, collection, core, iterables, patterns e testing. | CountdownTimer (quiver.async); MapCache (quiver.cache); MultiMap, TreeSet (quiver.collection); EnumerateIterable (quiver.iterables); center(), compareIgnoreCase(), isWhiteSpace() (quiver.strings) |
| [shelf][] | Fornece middleware de servidor web para Dart. Shelf facilita a criação e composição de servidores web e partes de servidores web. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace][] | Analisa, inspeciona e manipula stack traces que o Dart produz. Também transforma stack traces em um formato mais legível do que a implementação nativa StackTrace. Para saber mais, consulte [Desempacotando Packages: stack_trace.]({{site.news}}/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [test][] | Padroniza a escrita e execução de testes em Dart. | expect(), group(), test() |
| [yaml][] | Analisa a marcação YAML. | loadYaml(), loadYamlStream() |

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
[quiver]: {{pubpkg}}/quiver
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
