---
ia-translate: true
title: "Escrever servidores HTTP"
description: Comunicar-se pela internet
toc: false
prevpage:
  url: /tutorials/server/fetch-data
  title: Buscar dados da internet
---

Recursos Dart para escrever servidores HTTP incluem:

## Documentação {:#documentation}

* [Usando o Google Cloud][] tem informações sobre produtos Google Cloud
  que servidores Dart podem usar, como o Cloud Run.
* [Usando APIs Google][] aponta para recursos para ajudar você
  a usar Firebase e APIs de cliente Google a partir de um app Dart.

## Exemplos {:#samples}

* [Um servidor HTTP Dart simples][simple-sample]
  * Usa o pacote [`shelf`][].
  * Também usa os pacotes [`shelf_router`][] e [`shelf_static`][].
  * É implantável no Cloud Run.
* [Um servidor HTTP Dart que usa o Cloud Firestore][cloud-sample]
  * Usa os recursos do Cloud Firestore no pacote [`googleapis`][].
  * Também usa os pacotes [`googleapis_auth`][], [`shelf`][], e
    [`shelf_router`][].
  * É implantável no Cloud Run.

[cloud-sample]: {{site.repo.dart.org}}/samples/tree/main/server/google_apis
[`googleapis`]: {{site.pub-pkg}}/googleapis
[`googleapis_auth`]: {{site.pub-pkg}}/googleapis_auth
[`shelf`]: {{site.pub-pkg}}/shelf
[`shelf_router`]: {{site.pub-pkg}}/shelf_router
[`shelf_static`]: {{site.pub-pkg}}/shelf_static
[simple-sample]: {{site.repo.dart.org}}/samples/tree/main/server/simple
[Usando APIs Google]: /resources/google-apis
[Usando o Google Cloud]: /server/google-cloud