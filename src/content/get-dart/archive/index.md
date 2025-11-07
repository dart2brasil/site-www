---
title: Dart SDK archive
shortTitle: Archive
description: >-
  Download specific stable, beta, dev, and main channel versions of
  the Dart SDK and the Dart API documentation.
---

Use este arquivo para baixar
[versões específicas](/get-dart#release-channels) do
[Dart SDK](/tools/sdk) e da [documentação da API do Dart]({{site.dart-api}}).

Quer instalar o Dart usando o gerenciador de pacotes do seu sistema operacional?
[Obtenha o Dart.](/get-dart)

:::warning Notice
{% render 'install/sdk-terms.md' %}
:::

## Canal estável {:#stable-channel}

As builds do canal estável são testadas e aprovadas para uso em produção.

<ArchiveTable channel="stable" />

## Canal beta {:#beta-channel}

As builds do canal beta são pré-visualizações para o canal estável.
Recomendamos testar, mas não lançar, seus aplicativos no canal beta para pré-visualizar novos recursos ou testar a compatibilidade com versões futuras.
As builds do canal beta não são adequadas para uso em produção.

<ArchiveTable channel="beta" />

## Canal dev {:#dev-channel}

As builds do canal dev podem fornecer acesso antecipado a novos recursos, mas podem conter bugs.
As builds do canal dev não são adequadas para uso em produção.

<ArchiveTable channel="dev" />

## Canal main {:#main-channel}

As builds do canal main são as builds mais recentes e brutas do ramo `main` do repositório do Dart SDK.
Estas são as builds mais recentes disponíveis e provavelmente conterão bugs.
As builds do canal main são adequadas apenas para uso em desenvolvimento experimental, não para produção.

:::note
As builds do canal main não são assinadas.
:::

Para baixar uma build do canal main, use um
[URL do canal main](#main-channel-url-scheme).

## URLs de download {:#download-urls}

Você pode baixar arquivos zip para qualquer canal.

### Esquema de URL para os canais estável, beta e dev {:#stable-beta-and-dev-channel-url-scheme}

As versões dos canais estável, beta e dev estão disponíveis em URLs como as seguintes:

```plaintext
https://storage.googleapis.com/dart-archive/channels/<[!stable|beta|dev!]>/release/<[!version!]>/sdk/dartsdk-<[!platform!]>-<[!architecture!]>-release.zip
```

Exemplos:

```plaintext
https://storage.googleapis.com/dart-archive/channels/stable/release/3.6.2/sdk/dartsdk-windows-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/stable/release/3.0.7/sdk/dartsdk-macos-arm64-release.zip
https://storage.googleapis.com/dart-archive/channels/beta/release/2.8.0-20.11.beta/sdk/dartsdk-linux-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/dev/release/2.9.0-1.0.dev/sdk/dartsdk-linux-x64-release.zip
```

### Esquema de URL do canal main {:#main-channel-url-scheme}

A build mais recente do canal main está disponível em URLs como as seguintes:

```plaintext
https://storage.googleapis.com/dart-archive/channels/main/raw/latest/sdk/dartsdk-<[!platform!]>-<[!architecture!]>-release.zip
```

Exemplo:

```plaintext
https://storage.googleapis.com/dart-archive/channels/main/raw/latest/sdk/dartsdk-windows-x64-release.zip
```

:::note
As builds do canal main não são assinadas.
:::
