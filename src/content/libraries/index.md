---
ia-translate: true
title: Bibliotecas principais do Dart
shortTitle: Bibliotecas principais
description: Conheça as bibliotecas principais e as APIs do Dart.
nextpage:
  url: /libraries/dart-core
  title: dart:core
---

<style>
  th:first-child {
    width: 80%;
  }
</style>

O Dart tem um rico conjunto de bibliotecas principais que oferecem recursos essenciais para muitas
tarefas de programação do dia a dia, como
trabalhar com coleções de objetos (`dart:collection`),
fazer cálculos (`dart:math`)
e codificar/decodificar dados (`dart:convert`).
APIs adicionais estão disponíveis em
[pacotes comumente usados](/resources/useful-packages).

## Tour pelas bibliotecas {:#library-tour}

Os guias a seguir mostram como usar os principais recursos das bibliotecas principais do Dart.
Eles oferecem apenas uma visão geral e de forma alguma são abrangentes.
Sempre que precisar de mais detalhes sobre uma biblioteca ou seus membros,
consulte a [referência da API do Dart.][Dart API]

[dart:core](/libraries/dart-core)
: Tipos embutidos, coleções e outras funcionalidades principais.
  Esta biblioteca é importada automaticamente em todo programa Dart.

[dart:async](/libraries/dart-async)
: Suporte para programação assíncrona, com classes como Future e Stream.

[dart:math](/libraries/dart-math)
: Constantes e funções matemáticas, além de um gerador de números aleatórios.

[dart:convert](/libraries/dart-convert)
: Encoders e decoders para converter entre diferentes representações de dados,
  incluindo JSON e UTF-8.

[dart:io](/libraries/dart-io)
: E/S para programas que podem usar a VM do Dart,
  incluindo aplicações Flutter, servidores e scripts de linha de comando.

[dart:js_interop](/interop/js-interop)
: APIs para interoperabilidade com a plataforma web.
  Junto com `package:web`, `dart:js_interop` substitui `dart:html`.


Como mencionado, essas páginas são apenas uma visão geral;
elas cobrem apenas algumas bibliotecas dart:*
e nenhuma biblioteca de terceiros.

Para uma visão geral de todas as bibliotecas que o Dart oferece nas diferentes plataformas,
veja as listas [Bibliotecas multiplataforma](#multi-platform-libraries),
[Bibliotecas da plataforma nativa](#native-platform-libraries) e
[Bibliotecas da plataforma web](#web-platform-libraries) abaixo.

Outros lugares para encontrar informações sobre bibliotecas são o
[site pub.dev]({{site.pub}}) e o
[guia de bibliotecas para desenvolvedores web Dart][webdev libraries].
Você pode encontrar a documentação da API de todas as bibliotecas dart:* na
[referência da API do Dart][Dart API] ou, se estiver usando Flutter,
na [referência da API do Flutter][api-flutter].

Para saber mais sobre a linguagem Dart,
veja a [documentação e os exemplos da linguagem](/language).

[Dart API]: {{site.dart-api}}
[webdev libraries]: /web/libraries
[api-flutter]: {{site.flutter-api}}

## Bibliotecas multiplataforma {:#multi-platform-libraries}

A tabela a seguir lista as bibliotecas principais do Dart que funcionam em todas as
[plataformas Dart](/overview#platform).

| Biblioteca                                    | Notas                         |
|-----------------------------------------------|-------------------------------|
| [`dart:core`][dart-core]<br>Tipos embutidos, coleções e outras funcionalidades principais para todo programa Dart. | |
| [`dart:async`][dart-async], [`package:async`][package-async]<br>Suporte para programação assíncrona, com classes como `Future` e `Stream`.<br>`package:async` oferece utilitários adicionais para os tipos `Future` e `Stream`. | |
| [`dart:collection`][dart-collection], [`package:collection`][package-collection]<br>Classes e utilitários que complementam o suporte a coleções em `dart:core`.<br>`package:collection` oferece implementações de coleções adicionais e funções para trabalhar com coleções. | |
| [`dart:convert`][dart-convert], [`package:convert`][package-convert]<br>Encoders e decoders para converter entre diferentes representações de dados, incluindo JSON e UTF-8.<br>`package:convert` oferece encoders e decoders adicionais. ||
| [`dart:developer`][dart-developer]<br>Interação com ferramentas de desenvolvedor, como o debugger e o inspector. | Apenas [Native JIT][jit] e o [compilador JavaScript de desenvolvimento][development JavaScript compiler] |
| [`dart:math`][dart-math]<br>Constantes e funções matemáticas, além de um gerador de números aleatórios. | |
| [`dart:typed_data`][dart-typed_data], [`package:typed_data`][package-typed_data]<br>Listas que lidam com eficiência com dados de tamanho fixo (por exemplo, inteiros sem sinal de 8 bytes) e tipos numéricos SIMD.<br>`package:typed_data` oferece classes e funções adicionais que trabalham com dados tipados. | |

{:.table .table-striped}

## Bibliotecas da plataforma nativa {:#native-platform-libraries}

A tabela a seguir lista as bibliotecas principais do Dart que funcionam na
[plataforma nativa do Dart](/overview#native-platform) (código compilado AOT e JIT).

| Biblioteca                                    | Notas                         |
|-----------------------------------------------|-------------------------------|
| [`dart:ffi`][dart-ffi], [`package:ffi`][package-ffi]<br>Uma interface de função externa que permite ao código Dart usar APIs C nativas.<br>`package:ffi` contém utilitários, incluindo suporte para converter strings do Dart e strings C. | |
| [`dart:io`][dart-io], [`package:io`][package-io]<br>Suporte a arquivos, sockets, HTTP e outras operações de E/S para aplicações não web.<br>`package:io` oferece funcionalidades como suporte a cores ANSI, cópia de arquivos e códigos de saída padrão. | |
| [`dart:isolate`][dart-isolate]<br> Programação concorrente usando isolates: workers independentes, semelhantes a threads. | |
| [`dart:mirrors`][dart-mirrors] *(legado)* <br>Reflexão básica com suporte a introspecção e invocação dinâmica. | Descontinuada, apenas [Native JIT][jit] (_não_&nbsp;Flutter) |

{:.table .table-striped}

## Bibliotecas da plataforma web {:#web-platform-libraries}

A tabela a seguir lista as bibliotecas principais do Dart que funcionam na
[plataforma web do Dart](/overview#web-platform) (código compilado para JavaScript).
As ferramentas mais recentes e recomendadas estão em **negrito**, e as ferramentas legadas estão em *itálico*
(visite [Interoperabilidade JavaScript][JavaScript interoperability] para mais informações).

| Biblioteca                                    | Notas                         |
|-----------------------------------------------|-------------------------------|
| [**`package:web`**][pkg-web] <br>Bindings leves de APIs do navegador, construídos em torno da interoperabilidade JS | Substitui todas as bibliotecas web `dart:*`. Leia o [guia de migração][html-web]. |
| [**`dart:js_interop`**][js-interop] <br>Interoperabilidade com JavaScript e APIs do navegador. | Substitui `package:js`. |
| [**`dart:js_interop_unsafe`**][js-interop-unsafe] <br>Métodos utilitários para manipular objetos JavaScript dinamicamente. | Substitui `dart:js_util`. |
| [*`dart:html`*][dart-html] *(legado)* <br>Elementos HTML e outros recursos para aplicações baseadas na web. | Use `package:web` no lugar. |
| [*`dart:indexed_db`*][dart-indexed_db] *(legado)* <br>Armazenamento chave-valor no lado do cliente, com suporte a índices.  | Use `package:web` no lugar. |
| [*`dart:js`*][dart-js], [*`dart:js_util`*][dart-js_util], [*`package:js`*][package-js] *(legado)* <br>Primitivas de baixo nível e anotações de alto nível para interoperabilidade JS. | Use `dart:js_interop` ou `dart:js_interop_unsafe` no lugar. |
| [*`dart:svg`*][dart-svg] *(legado)* <br>Scalable Vector Graphics.  | Use `package:web` no lugar. |
| [*`dart:web_audio`*][dart-web_audio] *(legado)* <br>Programação de áudio de alta fidelidade no navegador. | Use `package:web` no lugar. |
| [*`dart:web_gl`*][dart-web_gl] *(legado)* <br>Programação 3D no navegador. | Use `package:web` no lugar. |

{:.table .table-striped}


<!---
Multi-platform libraries
-->
[dart-core]: {{site.dart-api}}/dart-core/dart-core-library.html
[dart-async]: {{site.dart-api}}/dart-async/dart-async-library.html
[package-async]: {{site.pub-pkg}}/async
[dart-collection]: {{site.dart-api}}/dart-collection/dart-collection-library.html
[package-collection]: {{site.pub-pkg}}/collection
[dart-convert]: {{site.dart-api}}/dart-convert/dart-convert-library.html
[package-convert]: {{site.pub-pkg}}/convert
[dart-developer]: {{site.dart-api}}/dart-developer/dart-developer-library.html
[dart-math]: {{site.dart-api}}/dart-math/dart-math-library.html
[dart-typed_data]: {{site.dart-api}}/dart-typed_data/dart-typed_data-library.html
[package-typed_data]: {{site.pub-pkg}}/typed_data

<!---
Native platform libraries
-->
[dart-ffi]: {{site.dart-api}}/dart-ffi/dart-ffi-library.html
[package-ffi]: {{site.pub-pkg}}/ffi
[dart-io]: {{site.dart-api}}/dart-io/dart-io-library.html
[package-io]: {{site.pub-pkg}}/io
[dart-isolate]: {{site.dart-api}}/dart-isolate/dart-isolate-library.html
[dart-mirrors]: {{site.dart-api}}/dart-mirrors/dart-mirrors-library.html

<!---
Web platform libraries
-->
[pkg-web]: {{site.pub-pkg}}/web
[js-interop]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[js-interop-unsafe]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[dart-html]: {{site.dart-api}}/dart-html/dart-html-library.html
[dart-indexed_db]: {{site.dart-api}}/dart-indexed_db/dart-indexed_db-library.html
[dart-js]: {{site.dart-api}}/dart-js/dart-js-library.html
[package-js]: {{site.pub-pkg}}/js
[dart-js_util]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[dart-svg]: {{site.dart-api}}/dart-svg/dart-svg-library.html
[dart-web_audio]: {{site.dart-api}}/dart-web_audio/dart-web_audio-library.html
[dart-web_gl]: {{site.dart-api}}/dart-web_gl/dart-web_gl-library.html

<!---
Misc
-->
[development JavaScript compiler]: /tools/webdev#serve
[jit]: /overview#native-platform
[JavaScript interoperability]: /interop/js-interop
[html-web]: /interop/js-interop/package-web
