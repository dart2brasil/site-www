---
ia-translate: true
title: "Visão geral do Dart SDK"
shortTitle: Visão geral do SDK
breadcrumb: SDK
description: Bibliotecas e ferramentas de linha de comando Dart.
---

O Dart SDK possui as bibliotecas e ferramentas de linha de comando que você precisa para desenvolver
aplicativos web, de linha de comando e de servidor Dart.
Para instalar o Dart SDK, veja [Obtenha o Dart](/get-dart).
Se você estiver desenvolvendo aplicativos Flutter, [instale o Flutter SDK][flutter].
O Flutter SDK inclui o Dart SDK.

Para saber mais sobre outras ferramentas que você pode usar para o desenvolvimento Dart,
consulte a página [Ferramentas Dart](/tools).

:::version-note
A menos que seja declarado o contrário,
a documentação e os exemplos deste site assumem
a versão `{{site.sdkVersion}}` do **Dart SDK**.
:::

{% comment %}
  IMPORTANTE: Após cada lançamento, EDITE src/_data/pkg-vers.json
  para atualizar o número da versão do SDK.
  Mais informações: https://github.com/dart-lang/site-www/wiki/Updating-to-new-SDK-releases
{% endcomment %}

## O que há no Dart SDK {:#what-s-in-the-dart-sdk}

O Dart SDK inclui dois diretórios:

* `lib` contém as [bibliotecas Dart][].
* `bin` contém as seguintes ferramentas de linha de comando.

[`dart`](/tools/dart-tool)
: A interface de linha de comando para criar, formatar, analisar, testar,
  documentar, compilar e executar código Dart.

[`dartaotruntime`](/tools/dartaotruntime)
: Um *runtime* Dart para *snapshots* (instantâneos) compilados AOT.

{% render 'tools/utf-8.md' %}

Para saber mais sobre o SDK, consulte o seu [arquivo README][readme].

## Support policy

The Dart team supports only the latest, stable version of the Dart SDK.
When a new major or minor version is released,
older versions are no longer supported.
For example, if `3.7.x` is the latest release,
it is supported until `3.8.0` or `4.0.0` is released,
whichever comes first.

The Dart team provides fixes to critical issues and security problems as needed
through patch releases but only for the currently supported version.
For example, if `3.7.0` is the latest stable release,
a fix to a vulnerability might be issued in a `3.7.1` patch release.

On average, the Dart team ships a new stable release every 3 months.
Patch releases to the currently supported version are shipped as needed.

This policy helps ensure Dart developers have access to
a stable and reliable platform that continues to
evolve with new features and improvements.

{% comment %}
TODO(parlough): Add a section discussing the breaking change policy
and link out to the breaking change index.
{% endcomment %}

## Filing bugs and feature requests

Para ver problemas existentes ou criar um novo,
acesse [o rastreador de problemas do SDK][sdk-issues].

[Bibliotecas Dart]: /libraries
[flutter]: {{site.flutter-docs}}/get-started/install
[readme]: {{site.repo.dart.sdk}}/blob/main/README.dart-sdk
[sdk-issues]: {{site.repo.dart.sdk}}/issues
