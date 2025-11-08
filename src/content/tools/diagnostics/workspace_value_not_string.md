---
title: workspace_value_not_string
description: >-
  Details about the workspace_value_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Workspace entries are required to be directory paths (strings)._

## Descrição

O analisador produz este diagnóstico quando a `workspace` list contains a
value that isn't a string.

## Exemplo

O código a seguir produz este diagnóstico porque the `workspace` list
contains a map:

```yaml
name: example
workspace:
    - [!image.gif: true!]
```

## Correções comuns

Change the `workspace` list so that it only contains valid POSIX-style directory
paths:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
