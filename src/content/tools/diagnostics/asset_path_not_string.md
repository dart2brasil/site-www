---
title: asset_path_not_string
description: >-
  Details about the asset_path_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Asset paths are required to be file paths (strings)._

## Descrição

O analisador produz este diagnóstico quando an asset map contains a
`path` value that isn't a string.

## Exemplo

O código a seguir produz este diagnóstico porque the asset map
contains a `path` value which is a list:

```yaml
name: example
flutter:
  assets:
    - path: [![one, two, three]!]
      flavors:
      - premium
```

## Correções comuns

Change the `asset` map so that it contains a `path` value which is a
string (a valid POSIX-style file path):

```yaml
name: example
flutter:
  assets:
    - path: image.gif
      flavors:
      - premium
```
