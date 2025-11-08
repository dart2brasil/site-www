---
title: enum_with_name_values
description: >-
  Details about the enum_with_name_values
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name 'values' is not a valid name for an enum._

## Descrição

O analisador produz este diagnóstico quando an enum is declared to have the
name `values`. This isn't allowed because the enum has an implicit static
field named `values`, and the two would collide.

## Exemplo

O código a seguir produz este diagnóstico porque there's an enum
declaration that has the name `values`:

```dart
enum [!values!] {
  c
}
```

## Correções comuns

Rename the enum to something other than `values`.
