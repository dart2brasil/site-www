---
title: asset_not_string_or_map
description: >-
  Details about the asset_not_string_or_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_An asset value is required to be a file path (string) or map._

## Descrição

O analisador produz este diagnóstico quando an asset value isn't a string
or a map.

## Exemplo

O código a seguir produz este diagnóstico porque the asset value
is a list:

```yaml
name: example
flutter:
  assets:
    - [![one, two, three]!]
```

## Correções comuns

If you need to specify more than just the path to the asset, then replace
the value with a map with a `path` key (a valid POSIX-style file path):

```yaml
name: example
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```

If you only need to specify the path, then replace the value with the path
to the asset (a valid POSIX-style file path):

```yaml
name: example
flutter:
  assets:
    - assets/image.gif
```
