---
ia-translate: true
title: Interoperabilidade com JavaScript
short-title: Interop JS
description: Integre código JavaScript ao seu aplicativo web Dart.
nextpage:
  url: /interop/js-interop/usage
  title: Usage
---

A [plataforma web Dart](/overview#web-platform) (Dart web platform) suporta a comunicação com aplicativos e bibliotecas JavaScript, bem como APIs do navegador, usando `dart:js_interop`.

Desenvolvedores web podem se beneficiar do uso de bibliotecas JS externas em seu código Dart, sem ter que reescrever nada em Dart.

## Interoperabilidade JS de nova geração {:#next-generation-js-interop}

A equipe Dart [recentemente][] reformulou o conjunto de recursos e APIs que permitem aos desenvolvedores acessar JavaScript e vinculações de navegador em seu código Dart.
Esta nova geração de interoperabilidade web não apenas melhora a experiência do usuário, mas também habilita o suporte a [Wasm][], alinhando o Dart ao futuro da Web.

A tabela a seguir mapeia as novas soluções de interoperabilidade JS e web do Dart para suas contrapartes anteriores:

| Novas bibliotecas de interoperabilidade | Bibliotecas anteriores                       |
|---------------------------------------|------------------------------------------|
| [`package:web`][]                     | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}

A integração Dart com JavaScript está em intenso desenvolvimento;
consulte a página [Interoperabilidade JS anterior][] para um resumo mais detalhado das iterações anteriores.

[recentemente]: https://medium.com/dartlang/dart-3-3-325bf2bf6c13
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
[Interoperabilidade JS anterior]: /interop/js-interop/past-js-interop/

## Visão geral {:#overview}

Para obter informações sobre como escrever e usar a interoperabilidade JavaScript:
  * [Referência de uso]
  * [Referência de tipos JS]

Para obter informações sobre como interagir com APIs web:
  * [`package:web` e migração]

Para tutoriais e ajuda:
  * [Como simular objetos de interoperabilidade JavaScript]

Para informações sobre bibliotecas anteriores de interoperabilidade JavaScript:
  * [Interoperabilidade JS anterior]

Para documentação adicional sobre interoperabilidade JavaScript:
  * [Referência da API `dart:js_interop`]
  * [Referência da API `dart:js_interop_unsafe`]

[Referência de uso]: /interop/js-interop/usage
[Referência de tipos JS]: /interop/js-interop/js-types
[`package:web` e migração]: /interop/js-interop/package-web
[Como simular objetos de interoperabilidade JavaScript]: /interop/js-interop/mock
[Interoperabilidade JS anterior]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html

