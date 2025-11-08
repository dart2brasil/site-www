---
ia-translate: true
title: Bibliotecas e pacotes web
shortTitle: Bibliotecas web
description: Bibliotecas e pacotes que podem ajudá-lo a escrever aplicações web Dart.
---

Dart fornece diversos pacotes e bibliotecas para suportar o desenvolvimento de
aplicativos web, sendo a opção recomendada o [`package:web`][web]. O [Dart SDK][Dart SDK]
também contém outras bibliotecas que fornecem APIs web de baixo nível.

## Soluções Web {:#web-solutions}

[Migrar para `package:web`][migrate]
: Aprenda como migrar para `package:web` a partir das soluções
  anteriores de biblioteca web do Dart, como [`dart:html`][html].

[`package:web` API reference][web]
: A solução de interoperabilidade web recomendada do Dart, `package:web`,
  expõe APIs do navegador com *bindings* leves construídos em torno da interoperação estática com JS (JavaScript).

[Documentação de interoperabilidade JavaScript][js]
: Aprenda como interagir com bibliotecas JavaScript ou TypeScript existentes
  usando o suporte de interoperação JS do Dart.

[`dart:js_interop` API reference][js_interop]
: A biblioteca web do Dart, `dart:js_interop`, fornece todos os membros
  necessários para facilitar a interoperação correta entre os tipos JavaScript e Dart.

[Suporte web do Flutter][flutter-web]
: O [framework Flutter][flutter] oferece suporte ao desenvolvimento web
  com Dart, além do suporte a dispositivos móveis, desktop e embarcados.

[Framework web Jaspr][jaspr]
: [Jaspr][jaspr] é um framework web Dart para construir sites rápidos e dinâmicos
  baseados em HTML.

[Construa uma aplicação web com Dart](/web/get-started)
: Uma visão geral rápida de como construir, executar e depurar uma aplicação web com Dart.

Para encontrar outras bibliotecas que oferecem suporte à plataforma web,
pesquise no pub.dev por [pacotes web][web packages].

[web]: {{site.pub-pkg}}/web
[Dart SDK]: {{site.dart-api}}
[migrate]: /interop/js-interop/package-web
[js_interop]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[flutter-web]: {{site.flutter-docs}}/platform-integration/web
[flutter]: {{site.flutter}}
[jaspr]: https://jaspr.site
[web packages]: {{site.pub}}/web
[html]: /libraries/dart-html
[js]: /interop/js-interop
