---
ia-translate: true
title: Usando APIs do Google
shortTitle: APIs do Google
description: Seus aplicativos Dart podem usar Firebase, APIs de cliente do Google e Genkit.
lastVerified: 2026-09-14
---

Esta página aponta para recursos que ajudam você a usar
[Firebase][], [APIs de cliente do Google][Google client APIs] e [Genkit Dart][] a partir de um aplicativo Dart.

## Firebase

A API Dart que você usa com Firebase depende
de você estar escrevendo código para um aplicativo Flutter ou para outro tipo de aplicativo Dart.

Aplicativos Flutter podem escolher entre muitos plugins com suporte oficial para
produtos populares do Firebase, como Analytics, Cloud Firestore,
Cloud Functions e Crashlytics.
Para uma lista completa desses plugins, consulte [FlutterFire][].

Outros tipos de aplicativos Dart podem usar
o [`firebase` package][], com suporte da comunidade.

## APIs de cliente do Google

O [`googleapis` package][] contém APIs geradas para
mais de 180 APIs de cliente do Google,
como a Google Docs API, a YouTube Data API,
a Cloud Translation API e a Cloud Storage API.

Se você estiver criando um aplicativo Flutter, consulte o
[guia Flutter para APIs do Google][flutter-google-apis].

Se você quiser usar APIs do Google como parte de um aplicativo servidor, consulte o
[exemplo de servidor google_apis][server-sample].

Alguns pacotes fornecem wrappers Dart idiomáticos para
as APIs fornecidas pelo `googleapis`.
Por exemplo, se você quiser usar a Google Sheets API,
considere o [`gsheets` package][],
que oferece uma [API alternativa][gsheets-api-docs] à
[API gerada automaticamente][gsheets-api-docs-gapi].

Para encontrar pacotes wrapper para APIs de cliente do Google, pesquise por
[pacotes que dependem de `googleapis`][gapi-packages].

## IA generativa com Genkit {:#genkit}

Para criar recursos com IA usando Google AI, Gemini e outros provedores de modelos,
use o [Genkit Dart][].
Genkit é um framework de código aberto que ajuda você a criar,
testar e implantar aplicações de IA prontas para produção e fluxos de trabalho agênticos.

Para começar, consulte a [documentação do Genkit Dart][Genkit Dart]
ou veja o [`genkit` package][] no pub.dev.


[Firebase]: https://firebase.google.com/use-cases
[FlutterFire]: https://firebase.flutter.dev/
[`firebase` package]: {{site.pub-pkg}}/firebase
[gapi-packages]: {{site.pub-pkg}}?q=dependency%3Agoogleapis
[Genkit Dart]: https://genkit.dev/docs/dart/get-started/
[`genkit` package]: {{site.pub-pkg}}/genkit
[Google client APIs]: https://developers.google.com/api-client-library
[`googleapis` package]: {{site.pub-pkg}}/googleapis
[`gsheets` package]: {{site.pub-pkg}}/gsheets
[gsheets-api-docs]: {{site.pub-api}}/gsheets/latest/gsheets/gsheets-library.html
[gsheets-api-docs-gapi]: {{site.pub-api}}/googleapis/latest/sheets_v4/sheets_v4-library.html
[flutter-google-apis]: {{site.flutter-docs}}/development/data-and-backend/google-apis
[server-sample]: {{site.repo.dart.samples}}/tree/main/server/google_apis
