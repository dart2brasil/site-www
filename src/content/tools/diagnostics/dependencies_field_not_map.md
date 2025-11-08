---
title: dependencies_field_not_map
description: >-
  Details about the dependencies_field_not_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The value of the '{0}' field is expected to be a map._

## Descrição

O analisador produz este diagnóstico quando the value of either the
`dependencies` or `dev_dependencies` key isn't a map.

## Exemplo

O código a seguir produz este diagnóstico porque the value of the
top-level `dependencies` key is a list:

```yaml
name: example
dependencies:
  [!- meta!]
```

## Correções comuns

Use a map as the value of the `dependencies` key:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
