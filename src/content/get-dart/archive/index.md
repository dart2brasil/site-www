---
ia-translate: true
title: Arquivo do SDK Dart
short-title: Arquivo
description: Baixe versões específicas dos canais stable, beta, dev e main do SDK Dart e a documentação da API Dart.
js:
- url: /assets/js/get-dart/download_archive.dart.js
  defer: true
- url: /assets/js/get-dart/install.js
  defer: true
---

Use este arquivo para baixar
[versões específicas](/get-dart#release-channels) do
[SDK Dart](/tools/sdk) e a [documentação da API Dart]({{site.dart-api}}).

Quer instalar o Dart com o gerenciador de pacotes do seu SO?
[Obtenha o Dart.](/get-dart)

:::warning Aviso
{% include './_sdk-terms.md' %}
:::

## Canal stable

Os builds do canal stable são testados e aprovados para uso em produção.

{% include './_archives_table.html', channel:'stable' %}

## Canal beta

Os builds do canal beta são builds de pré-visualização para o canal stable.
Recomendamos testar, mas não lançar, seus aplicativos com o beta
para visualizar novos recursos ou testar a compatibilidade com versões futuras.
Os builds do canal beta não são adequados para uso em produção.

{% include './_archives_table.html', channel:'beta' %}

## Canal dev

Os builds do canal dev podem fornecer acesso antecipado
a novos recursos, mas podem conter bugs.
Os builds do canal dev não são adequados para uso em produção.

{% include './_archives_table.html', channel:'dev' %}

## Canal main

Os builds do canal main são os builds mais recentes e brutos da branch
`main` do repositório do SDK Dart.
Esses são os builds mais recentes disponíveis,
e é provável que contenham bugs.
Os builds do canal main são adequados apenas para
uso em desenvolvimento experimental, não para uso em produção.

:::note
Os builds do canal main não são assinados.
:::

Para baixar um build do canal main, use um
[URL do canal main](#main-channel-url-scheme).

## URLs de download

Você pode baixar arquivos zip para qualquer canal.

### Esquema de URL dos canais stable, beta e dev

Os lançamentos dos canais stable, beta e dev
estão disponíveis em URLs como os seguintes:

```plaintext
https://storage.googleapis.com/dart-archive/channels/<[!stable|beta|dev!]>/release/<[!version!]>/sdk/dartsdk-<[!platform!]>-<[!architecture!]>-release.zip
```

Exemplos:

```plaintext
https://storage.googleapis.com/dart-archive/channels/stable/release/2.7.2/sdk/dartsdk-windows-ia32-release.zip
https://storage.googleapis.com/dart-archive/channels/stable/release/2.1.1/sdk/dartsdk-macos-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/beta/release/2.8.0-20.11.beta/sdk/dartsdk-linux-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/dev/release/2.9.0-1.0.dev/sdk/dartsdk-linux-x64-release.zip
```

### Esquema de URL do canal main

O build mais recente do canal main
está disponível em URLs como os seguintes:

```plaintext
https://storage.googleapis.com/dart-archive/channels/main/raw/latest/sdk/dartsdk-<[!platform!]>-<[!architecture!]>-release.zip
```

Exemplo:

```plaintext
https://storage.googleapis.com/dart-archive/channels/main/raw/latest/sdk/dartsdk-windows-x64-release.zip
```

:::note
Os builds do canal main não são assinados.
:::
