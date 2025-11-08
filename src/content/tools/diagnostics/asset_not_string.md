---
ia-translate: true
title: asset_not_string
description: >-
  Detalhes sobre o diagnóstico asset_not_string
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Assets are required to be file paths (strings)._

## Description

O analisador produz este diagnóstico quando uma lista de `assets` contém um
valor que não é uma string.

## Example

O código a seguir produz este diagnóstico porque a lista de `assets`
contém um mapa:

```yaml
name: example
flutter:
  assets:
    - [!image.gif: true!]
```

## Common fixes

Altere a lista de `assets` para que ela contenha apenas caminhos de arquivo válidos no
estilo POSIX:

```yaml
name: example
flutter:
  assets:
    - assets/image.gif
```
