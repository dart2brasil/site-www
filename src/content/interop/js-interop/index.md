---
ia-translate: true
title: Interoperabilidade JavaScript
short-title: JS interop
description: Integre código JavaScript em seu aplicativo web Dart.
---

A [plataforma web Dart][Dart web platform] suporta comunicação
com aplicativos e bibliotecas JavaScript, bem como APIs de navegador, usando `dart:js_interop`.

Desenvolvedores web podem se beneficiar do uso de bibliotecas
JS externas em seu código Dart, sem ter que reescrever nada em Dart.

## Nova geração de JS interop

A equipe do Dart [recentemente][recently] reformulou a coleção de recursos e APIs que permitem aos
desenvolvedores acesso a vinculações JavaScript e de navegador em seu código Dart.
Esta nova geração de interoperabilidade web não apenas melhora a experiência do usuário, mas
também possibilita o suporte a [Wasm][Wasm], alinhando o Dart com o futuro da Web.

A tabela a seguir mapeia as novas soluções de interoperabilidade JS e web do Dart para suas
contrapartes anteriores:

| Novas bibliotecas de interop | Bibliotecas anteriores |
| ---------------------------- | ------------------------ |
| [`package:web`][`package:web`] | [`dart:html`][`dart:html`] <br> [`dart:indexed_db`][`dart:indexed_db`] <br> [`dart:svg`][`dart:svg`] <br> [`dart:web_audio`][`dart:web_audio`] <br> [`dart:web_gl`][`dart:web_gl`] |
| [`dart:js_interop`][`dart:js_interop`] <br> [`dart:js_interop_unsafe`][`dart:js_interop_unsafe`] | [`package:js`][`package:js`] <br> [`dart:js`][`dart:js`] <br> [`dart:js_util`][`dart:js_util`] |

{:.table .table-striped}

A história de interop do Dart tem estado sob intenso desenvolvimento há algum tempo;
confira a página [interop JS no passado][Past JS interop] para um resumo mais detalhado sobre
iterações anteriores.

[recently]: https://medium.com/dartlang/dart-3-3-325bf2bf6c13
[Wasm]: /web/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:html`]: {{site.dart-api}}/dart-html/dart-html-library.html
[`dart:svg`]: {{site.dart-api}}/dart-svg/dart-svg-library.html
[`dart:indexed_db`]: {{site.dart-api}}/dart-indexed_db/dart-indexed_db-library.html
[`dart:web_audio`]: {{site.dart-api}}/dart-web_audio/dart-web_audio-library.html
[`dart:web_gl`]: {{site.dart-api}}/dart-web_gl/dart-web_gl-library.html
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[`package:js`]: {{site.pub-api}}/js
[`dart:js`]: {{site.dart-api}}/dart-js/dart-js-library.html
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[Past JS interop]: /interop/js-interop/past-js-interop/

## Visão geral

Para informações sobre como escrever e usar a interoperabilidade JavaScript:

  *   [Referência de uso][Usage reference]
  *   [Referência de tipos JS][JS types reference]

Para informações sobre como interagir com APIs da web:

  *   [`package:web` e migração][`package:web` and migration]

Para tutoriais e ajuda:

  *   [Como simular objetos de interoperabilidade JavaScript][How to mock JavaScript interop objects]

Para informações sobre bibliotecas de interoperabilidade JavaScript anteriores:

  *   [Interop JS no passado][Past JS interop]

Para documentação adicional sobre interoperabilidade JavaScript:

  *   [Referência da API `dart:js_interop`][`dart:js_interop` API reference]
  *   [Referência da API `dart:js_interop_unsafe`][`dart:js_interop_unsafe` API reference]

[Dart web platform]: /overview#web-platform
[Usage reference]: /interop/js-interop/usage
[JS types reference]: /interop/js-interop/js-types
[`package:web` and migration]: /interop/js-interop/package-web
[How to mock JavaScript interop objects]: /interop/js-interop/mock
[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
