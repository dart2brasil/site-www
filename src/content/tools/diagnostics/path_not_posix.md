---
title: path_not_posix
description: >-
  Details about the path_not_posix
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The path '{0}' isn't a POSIX-style path._

## Descrição

O analisador produz este diagnóstico quando a dependency has a `path` key
whose value is a string, but isn't a POSIX-style path.

## Exemplo

O código a seguir produz este diagnóstico porque the path following the
`path` key is a Windows path:

```yaml
name: example
dependencies:
  local_package:
    path: [!E:\local_package!]
```

## Correções comuns

Convert the path to a POSIX path.
