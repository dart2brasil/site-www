---
title: asset_not_string
description: >-
  Details about the asset_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Assets are required to be file paths (strings)._

## Descrição

O analisador produz este diagnóstico quando an `assets` list contains a
value that isn't a string.

## Exemplo

O código a seguir produz este diagnóstico porque the `assets` list
contains a map:

```yaml
name: example
flutter:
  assets:
    - [!image.gif: true!]
```

## Correções comuns

Change the `assets` list so that it only contains valid POSIX-style file
paths:

```yaml
name: example
flutter:
  assets:
    - assets/image.gif
```
