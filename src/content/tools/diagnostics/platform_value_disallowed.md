---
ia-translate: true
title: platform_value_disallowed
description: >-
  Detalhes sobre o diagnóstico platform_value_disallowed
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Chaves no campo `platforms` não podem ter valores._

## Description

O analisador produz este diagnóstico quando uma chave no map `platforms`
tem um valor.
Para saber mais sobre especificar as plataformas suportadas do seu pacote,
confira a [documentação sobre declarações de plataforma](https://dart.dev/tools/pub/pubspec#platforms).

## Example

O seguinte `pubspec.yaml` produz este diagnóstico porque a chave
`web` tem um valor.

```yaml
name: example
platforms:
  web: [!"chrome"!]
```

## Common fixes

Omita o valor e deixe a chave sem um valor:

```yaml
name: example
platforms:
  web:
```

Valores para chaves no campo `platforms` estão atualmente reservados para
comportamento futuro potencial.
