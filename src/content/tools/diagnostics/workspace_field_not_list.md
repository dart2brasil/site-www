---
title: workspace_field_not_list
description: >-
  Details about the workspace_field_not_list
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The value of the 'workspace' field is required to be a list of relative file paths._

## Descrição

O analisador produz este diagnóstico quando the value of the `workspace` key
isn't a list.

## Exemplo

O código a seguir produz este diagnóstico porque the value of the
`workspace` key is a string when a list is expected:

```yaml
name: example
workspace: [!notPaths!]
```

## Correções comuns

Change the value of the workspace field so that it's a list:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
