---
title: Using Google APIs
shortTitle: Google APIs
description: Your Dart apps can use Firebase and Google client APIs.
lastVerified: 2021-05-13
---

Esta página aponta para recursos para ajudar você a usar
[Firebase][Firebase] e [APIs de cliente do Google][Google client APIs] a partir de um aplicativo Dart.


## Firebase {:#firebase}

A API Dart que você usa com o Firebase depende
se você está escrevendo código para um aplicativo Flutter ou outro tipo de aplicativo Dart.

Aplicativos Flutter podem escolher entre muitos plugins oficialmente suportados para
produtos populares do Firebase como Analytics, Cloud Firestore,
Cloud Functions e Crashlytics.
Para uma lista completa desses plugins, veja [FlutterFire][FlutterFire].

Outros tipos de aplicativos Dart podem usar
o pacote [`firebase`][`firebase` package] com suporte da comunidade.

## APIs de cliente do Google {:#google-client-apis}

O pacote [`googleapis`][`googleapis` package] contém APIs geradas para
mais de 180 APIs de cliente do Google,
como a API do Google Docs, API do YouTube Data,
API do Cloud Translation e API do Cloud Storage.

Se você está construindo um aplicativo Flutter, veja o
[guia do Flutter para APIs do Google][flutter-google-apis].

Se você gostaria de usar APIs do Google como parte de um aplicativo de servidor, veja o
[exemplo de servidor google_apis][server-sample].

Alguns pacotes fornecem wrappers (envoltórios) idiomáticos Dart para
as APIs fornecidas por `googleapis`.
Por exemplo, se você quiser usar a API do Google Sheets,
considere o pacote [`gsheets`][`gsheets` package],
que fornece uma [API alternativa][gsheets-api-docs] para a
[API gerada automaticamente][gsheets-api-docs-gapi].

Para encontrar pacotes wrapper para APIs de cliente do Google, procure por
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
