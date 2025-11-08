---
ia-translate: true
title: asset_missing_path
description: "Detalhes sobre o diagnóstico asset_missing_path produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Asset map entry must contain a 'path' field._

## Description

O analisador produz este diagnóstico quando um mapa de asset está sem um
valor `path`.

## Example

O código a seguir produz este diagnóstico porque o mapa de asset
está sem um valor `path`:

```yaml
name: example
flutter:
  assets:
    - flavors:
      - premium
```

## Common fixes

Altere o mapa de asset para que ele contenha um campo `path` com um valor
string (um caminho de arquivo válido no estilo POSIX):

```yaml
name: example
flutter:
  assets:
    - path: assets/image.gif
      flavors:
      - premium
```
