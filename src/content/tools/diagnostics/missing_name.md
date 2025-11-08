---
title: missing_name
description: >-
  Details about the missing_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The 'name' field is required but missing._

## Descrição

O analisador produz este diagnóstico quando there's no top-level `name` key.
The `name` key provides the name of the package, which is required.

## Exemplo

O código a seguir produz este diagnóstico porque the package doesn't
have a name:

```yaml
dependencies:
  meta: ^1.0.2
```

## Correções comuns

Add the top-level key `name` with a value that's the name of the package:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
