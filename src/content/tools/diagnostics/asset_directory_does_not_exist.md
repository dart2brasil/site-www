---
title: asset_directory_does_not_exist
description: >-
  Details about the asset_directory_does_not_exist
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The asset directory '{0}' doesn't exist._

## Descrição

O analisador produz este diagnóstico quando an asset list contains a value
referencing a directory that doesn't exist.

## Exemplo

Assuming that the directory `assets` doesn't exist, the following code
produces this diagnostic because it's listed as a directory containing
assets:

```yaml
name: example
flutter:
  assets:
    - [!assets/!]
```

## Correções comuns

If the path is correct, then create a directory at that path.

If the path isn't correct, then change the path to match the path of the
directory containing the assets.
