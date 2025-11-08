---
ia-translate: true
title: "Escrever servidores HTTP"
description: Comunicar pela internet
showToc: false
prevpage:
  url: /tutorials/server/fetch-data
  title: Buscar dados da internet
---

Recursos Dart para escrever servidores HTTP incluem:

## Documentação

* [Usando Google Cloud][Using Google Cloud] tem informações sobre produtos Google Cloud
  que servidores Dart podem usar, como Cloud Run.
* [Usando APIs Google][Using Google APIs] aponta para recursos para ajudá-lo a
  usar Firebase e APIs cliente Google de uma aplicação Dart.

## Exemplos

* [Um servidor HTTP Dart simples][simple-sample]
  * Usa o pacote [`shelf`][].
  * Também usa os pacotes [`shelf_router`][] e [`shelf_static`][].
  * É implantável no Cloud Run.
* [Um servidor HTTP Dart que usa Cloud Firestore][cloud-sample]
  * Usa os recursos do Cloud Firestore no pacote [`googleapis`][].
  * Também usa os pacotes [`googleapis_auth`][], [`shelf`][] e
    [`shelf_router`][].
  * É implantável no Cloud Run.

[cloud-sample]: {{site.repo.dart.samples}}/tree/main/server/google_apis
[`googleapis`]: {{site.pub-pkg}}/googleapis
[`googleapis_auth`]: {{site.pub-pkg}}/googleapis_auth
[`shelf`]: {{site.pub-pkg}}/shelf
[`shelf_router`]: {{site.pub-pkg}}/shelf_router
[`shelf_static`]: {{site.pub-pkg}}/shelf_static
[simple-sample]: {{site.repo.dart.samples}}/tree/main/server/simple
[Using Google APIs]: /resources/google-apis
[Using Google Cloud]: /server/google-cloud
