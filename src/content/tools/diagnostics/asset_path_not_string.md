---
ia-translate: true
title: asset_path_not_string
description: "Detalhes sobre o diagnóstico asset_path_not_string produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Asset paths are required to be file paths (strings)._

## Description

O analisador produz este diagnóstico quando um mapa de asset contém um
valor `path` que não é uma string.

## Example

O código a seguir produz este diagnóstico porque o mapa de asset
contém um valor `path` que é uma lista:

```yaml
name: example
flutter:
  assets:
    - path: [![one, two, three]!]
      flavors:
      - premium
```

## Common fixes

Altere o mapa de `asset` para que ele contenha um valor `path` que seja uma
string (um caminho de arquivo válido no estilo POSIX):

```yaml
name: example
flutter:
  assets:
    - path: image.gif
      flavors:
      - premium
```
