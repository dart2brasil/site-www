---
title: asset_missing_path
description: >-
  Details about the asset_missing_path
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Asset map entry must contain a 'path' field._

## Descrição

O analisador produz este diagnóstico quando an asset map is missing a
`path` value.

## Exemplo

O código a seguir produz este diagnóstico porque the asset map
is missing a `path` value:

```yaml
name: example
flutter:
  assets:
    - flavors:
      - premium
```

## Correções comuns

Change the asset map so that it contains a `path` field with a string
value (a valid POSIX-style file path):

```yaml
name: example
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```
