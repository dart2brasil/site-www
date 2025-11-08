---
ia-translate: true
title: Bibliotecas e pacotes web
shortTitle: Bibliotecas web
description: Bibliotecas e pacotes que podem ajudar você a escrever aplicações web em Dart.
---

Dart fornece vários pacotes e bibliotecas para suportar
o desenvolvimento de aplicações web, sendo a opção recomendada o [`package:web`][web].
O [Dart SDK][] também contém outras bibliotecas que fornecem APIs web de baixo nível.

## Soluções web

[Migrar para `package:web`][migrate]
: Aprenda como migrar para `package:web`
  a partir das soluções de biblioteca web anteriores do Dart, como [`dart:html`][html].

[Referência da API do `package:web`][web]
: A solução de interoperabilidade web recomendada do Dart, `package:web`, expõe
  APIs do navegador com bindings leves construídos em torno de interoperabilidade JS estática.

[Documentação de interoperabilidade JavaScript][js]
: Aprenda como interagir com bibliotecas JavaScript ou TypeScript existentes
  usando o suporte de interoperabilidade JS do Dart.

[Referência da API do `dart:js_interop`][js_interop]
: A biblioteca web do Dart `dart:js_interop` fornece todos os membros necessários para
  facilitar a interoperabilidade sound entre tipos JavaScript e Dart.

[Suporte web do Flutter][flutter-web]
: O [framework Flutter][flutter] suporta desenvolvimento web com Dart,
  além de suporte para mobile, desktop e dispositivos embarcados.

[Framework web Jaspr][jaspr]
: [Jaspr][jaspr] é um framework web Dart para construir sites
  HTML rápidos e dinâmicos.

[Construa uma aplicação web com Dart](/web/get-started)
: Uma rápida visão geral de como construir, executar e depurar uma aplicação web com Dart.

Para encontrar outras bibliotecas que suportam a plataforma web,
pesquise em pub.dev por [pacotes web][web packages].

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
