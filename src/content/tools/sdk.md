---
ia-translate: true
title: Visão Geral do Dart SDK
description: Bibliotecas Dart e ferramentas de linha de comando.
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

## Registrando bugs e solicitações de recursos {:#filing-bugs-and-feature-requests}

Para ver problemas existentes ou criar um novo,
acesse [o rastreador de problemas do SDK][sdk-issues].

[Bibliotecas Dart]: /libraries
[flutter]: {{site.flutter-docs}}/get-started/install
[readme]: {{site.repo.dart.sdk}}/blob/main/README.dart-sdk
[sdk-issues]: {{site.repo.dart.sdk}}/issues
