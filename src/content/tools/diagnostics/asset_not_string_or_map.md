---
ia-translate: true
title: asset_not_string_or_map
description: >-
  Detalhes sobre o diagnóstico asset_not_string_or_map
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_An asset value is required to be a file path (string) or map._

## Description

O analisador produz este diagnóstico quando um valor de asset não é uma string
ou um mapa.

## Example

O código a seguir produz este diagnóstico porque o valor do asset
é uma lista:

```yaml
name: example
flutter:
  assets:
    - [![one, two, three]!]
```

## Common fixes

Se você precisa especificar mais do que apenas o caminho para o asset, então substitua
o valor por um mapa com uma chave `path` (um caminho de arquivo válido no estilo POSIX):

```yaml
name: example
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```

Se você precisa apenas especificar o caminho, então substitua o valor pelo caminho
para o asset (um caminho de arquivo válido no estilo POSIX):

```yaml
name: example
flutter:
  assets:
    - assets/image.gif
```
