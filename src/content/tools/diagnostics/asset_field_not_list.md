---
ia-translate: true
title: asset_field_not_list
description: "Detalhes sobre o diagnóstico asset_field_not_list produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The value of the 'assets' field is expected to be a list of relative file paths._

## Description

O analisador produz este diagnóstico quando o valor da chave `assets`
não é uma lista.

## Example

O código a seguir produz este diagnóstico porque o valor da
chave `assets` é uma string quando uma lista é esperada:

```yaml
name: example
flutter:
  assets: [!assets/!]
```

## Common fixes

Altere o valor da lista de assets para que seja uma lista:

```yaml
name: example
flutter:
  assets:
    - assets/
```
