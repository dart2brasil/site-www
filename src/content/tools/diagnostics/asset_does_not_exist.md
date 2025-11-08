---
title: asset_does_not_exist
description: >-
  Details about the asset_does_not_exist
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The asset file '{0}' doesn't exist._

## Descrição

O analisador produz este diagnóstico quando an asset list contains a value
referencing a file that doesn't exist.

## Exemplo

Assuming that the file `doesNotExist.gif` doesn't exist, the following code
produces this diagnostic because it's listed as an asset:

```yaml
name: example
flutter:
  assets:
    - [!doesNotExist.gif!]
```

## Correções comuns

If the path is correct, then create a file at that path.

If the path isn't correct, then change the path to match the path of the
file containing the asset.
