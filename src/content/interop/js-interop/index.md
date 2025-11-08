---
ia-translate: true
title: Interoperabilidade JavaScript
shortTitle: JS interop
description: Integre código JavaScript na sua aplicação web Dart.
nextpage:
  url: /interop/js-interop/usage
  title: Usage
---

Integre perfeitamente bibliotecas e APIs JavaScript na sua aplicação web Dart.

## Visão geral {: #overview }

A [plataforma web Dart][Dart web platform] fornece ferramentas poderosas para
chamar JavaScript do Dart e vice-versa e permite que você aproveite o vasto
ecossistema JavaScript sem sair do seu código Dart.

Esta página fornece um hub central para aprender sobre interoperabilidade JavaScript
no Dart. Você encontrará recursos para começar, guias de uso detalhados e
informações sobre a biblioteca `dart:js_interop` mais recente. Se você está procurando usar
uma biblioteca JavaScript específica, ou interagir com APIs do navegador, este é o
lugar para começar.

Comece com JS interop:
  * [Começando com interop Javascript][Getting started with Javascript interop]
  * [Como fazer mock de objetos de interop JavaScript][How to mock JavaScript interop objects]

Revise os guias de referência:
  * [Referência de uso][Usage reference]
  * [Referência de tipos JS][JS types reference]

Interaja com o navegador:
  * [`package:web` e migração][`package:web` and migration]

[Dart web platform]: /web
[Usage reference]: /interop/js-interop/usage
[JS types reference]: /interop/js-interop/js-types
[`package:web` and migration]: /interop/js-interop/package-web
[Getting started with Javascript interop]: /interop/js-interop/start
[How to mock JavaScript interop objects]: /interop/js-interop/mock

## A evolução da interoperabilidade JavaScript {: #next-generation-js-interop }

[Dart 3.3][] introduz uma nova geração de JS interop que oferece
um conjunto unificado de funcionalidades e APIs para acessar JavaScript e
funcionalidades do navegador dentro do seu código Dart. Esta abordagem moderna melhora a
experiência do desenvolvedor e habilita suporte a WebAssembly ([Wasm][]), alinhando
Dart com o futuro da web.

A seguinte tabela mapeia as novas soluções de interop JS e web do Dart para
suas contrapartes anteriores:

| Novas bibliotecas de interop | Bibliotecas anteriores                   |
|------------------------------|------------------------------------------|
| [`package:web`][] | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}

[Dart 3.3]: https://blog.dart.dev/dart-3-3-325bf2bf6c13
[Wasm]: /web/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:html`]: {{site.dart-api}}/dart-html/
[`dart:svg`]: {{site.dart-api}}/dart-svg/
[`dart:indexed_db`]: {{site.dart-api}}/dart-indexed_db/
[`dart:web_audio`]: {{site.dart-api}}/dart-web_audio/
[`dart:web_gl`]: {{site.dart-api}}/dart-web_gl/
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`package:js`]: {{site.pub-api}}/js
[`dart:js`]: {{site.dart-api}}/dart-js/
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/

## Trabalhar com funcionalidades descontinuadas {: #deprecated-features }

Se você mantém código legado, pode continuar a trabalhar com algumas funcionalidades descontinuadas.
Para aprender mais sobre funcionalidades descontinuadas de JS interop, veja o guia [JS interop passado][Past JS interop].

## Recursos adicionais {: #additional-resources }

Bibliotecas anteriores de interoperabilidade JavaScript:
  * [JS interop passado][Past JS interop]

Documentação adicional sobre interoperabilidade JavaScript:
  * [Referência da API `dart:js_interop`][`dart:js_interop` API reference]
  * [Referência da API `dart:js_interop_unsafe`][`dart:js_interop_unsafe` API reference]

[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/
