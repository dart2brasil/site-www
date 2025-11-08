---
title: Dart SDK overview
shortTitle: SDK overview
breadcrumb: SDK
description: Dart libraries and command-line tools.
ia-translate: true
---

O Dart SDK possui as bibliotecas e ferramentas de linha de comando necessárias para desenvolver
aplicativos web, de linha de comando e de servidor em Dart.
Para instalar o Dart SDK, consulte [Get Dart](/get-dart).
Se você está desenvolvendo aplicativos Flutter, [instale o Flutter SDK][flutter].
O Flutter SDK inclui o Dart SDK.

Para aprender sobre outras ferramentas que você pode usar para desenvolvimento Dart,
confira a página [Dart tools](/tools).

:::version-note
A menos que indicado o contrário,
a documentação e exemplos deste site assumem
a versão `{{site.sdkVersion}}` do **Dart SDK**.
:::

{% comment %}
  IMPORTANT: After each release, EDIT src/_data/pkg-vers.json
  to update the SDK version number.
  More info: https://github.com/dart-lang/site-www/wiki/Updating-to-new-SDK-releases
{% endcomment %}

## O que está no Dart SDK

O Dart SDK inclui dois diretórios:

* `lib` contém as [bibliotecas Dart][Dart libraries].
* `bin` contém as seguintes ferramentas de linha de comando.

[`dart`](/tools/dart-tool)
: A interface de linha de comando para criar, formatar, analisar, testar,
  documentar, compilar e executar código Dart.

[`dartaotruntime`](/tools/dartaotruntime)
: Um runtime Dart para snapshots compilados com AOT.

{% render 'tools/utf-8.md' %}

Para saber mais sobre o SDK, confira seu [arquivo README][readme].

## Política de suporte

A equipe Dart oferece suporte apenas à versão estável mais recente do Dart SDK.
Quando uma nova versão principal ou secundária é lançada,
as versões mais antigas não são mais suportadas.
Por exemplo, se `3.7.x` é o lançamento mais recente,
ele é suportado até que `3.8.0` ou `4.0.0` seja lançado,
o que ocorrer primeiro.

A equipe Dart fornece correções para problemas críticos e de segurança conforme necessário
por meio de patch releases, mas apenas para a versão atualmente suportada.
Por exemplo, se `3.7.0` é a versão estável mais recente,
uma correção para uma vulnerabilidade pode ser lançada em um patch release `3.7.1`.

Em média, a equipe Dart lança uma nova versão estável a cada 3 meses.
Patch releases para a versão atualmente suportada são lançados conforme necessário.

Esta política ajuda a garantir que os desenvolvedores Dart tenham acesso a
uma plataforma estável e confiável que continua a
evoluir com novos recursos e melhorias.

{% comment %}
TODO(parlough): Add a section discussing the breaking change policy
and link out to the breaking change index.
{% endcomment %}

## Reportando bugs e solicitações de recursos

Para ver problemas existentes ou criar um novo,
acesse [o rastreador de problemas do SDK][sdk-issues].

[Dart libraries]: /libraries
[flutter]: {{site.flutter-docs}}/get-started/install
[readme]: {{site.repo.dart.sdk}}/blob/main/README.dart-sdk
[sdk-issues]: {{site.repo.dart.sdk}}/issues
