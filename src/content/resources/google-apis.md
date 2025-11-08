---
title: Usando APIs do Google
shortTitle: APIs do Google
description: Seus aplicativos Dart podem usar Firebase e APIs de cliente do Google.
lastVerified: 2021-05-13
ia-translate: true
---

Esta página aponta para recursos para ajudá-lo a usar
[Firebase][] e [APIs de cliente do Google][Google client APIs] a partir de um aplicativo Dart.


## Firebase

A API Dart que você usa com Firebase depende
se você está escrevendo código para um aplicativo Flutter ou outro tipo de aplicativo Dart.

Aplicativos Flutter podem escolher entre muitos plugins oficialmente suportados para
produtos populares do Firebase, como Analytics, Cloud Firestore,
Cloud Functions e Crashlytics.
Para uma lista completa desses plugins, consulte [FlutterFire][].

Outros tipos de aplicativos Dart podem usar
o [`firebase` package][] com suporte da comunidade.

## APIs de cliente do Google

O [`googleapis` package][] contém APIs geradas para
mais de 180 APIs de cliente do Google,
como a API do Google Docs, API de Dados do YouTube,
API Cloud Translation e API Cloud Storage.

Se você está construindo um aplicativo Flutter, consulte o
[guia Flutter para APIs do Google][flutter-google-apis].

Se você deseja usar APIs do Google como parte de um aplicativo servidor, consulte o
[exemplo de servidor google_apis][server-sample].

Alguns pacotes fornecem wrappers Dart idiomáticos para
as APIs fornecidas por `googleapis`.
Por exemplo, se você deseja usar a API do Google Sheets,
considere o [`gsheets` package][],
que fornece uma [API alternativa][gsheets-api-docs] à
[API gerada automaticamente][gsheets-api-docs-gapi].

Para encontrar pacotes wrapper para APIs de cliente do Google, pesquise por
[pacotes que dependem de `googleapis`][gapi-packages].


[Firebase]: https://firebase.google.com/use-cases
[FlutterFire]: https://firebase.flutter.dev/
[`firebase` package]: {{site.pub-pkg}}/firebase
[gapi-packages]: {{site.pub-pkg}}?q=dependency%3Agoogleapis
[Google client APIs]: https://developers.google.com/api-client-library
[`googleapis` package]: {{site.pub-pkg}}/googleapis
[`gsheets` package]: {{site.pub-pkg}}/gsheets
[gsheets-api-docs]: {{site.pub-api}}/gsheets/latest/gsheets/gsheets-library.html
[gsheets-api-docs-gapi]: {{site.pub-api}}/googleapis/latest/sheets_v4/sheets_v4-library.html
[flutter-google-apis]: {{site.flutter-docs}}/development/data-and-backend/google-apis
[server-sample]: {{site.repo.dart.samples}}/tree/main/server/google_apis
