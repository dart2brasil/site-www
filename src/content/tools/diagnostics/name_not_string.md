---
title: name_not_string
description: >-
  Details about the name_not_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The value of the 'name' field is required to be a string._

## Descrição

O analisador produz este diagnóstico quando the top-level `name` key has a
value that isn't a string.

## Exemplo

O código a seguir produz este diagnóstico porque the value following the
`name` key is a list:

```yaml
name:
  [!- example!]
```

## Correções comuns

Replace the value with a string:

```yaml
name: example
```
