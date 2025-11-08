---
title: duplicate_field_name
description: >-
  Details about the duplicate_field_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The field name '{0}' is already used in this record._

## Descrição

O analisador produz este diagnóstico quando either a record literal or a
record type annotation contains a field whose name is the same as a
previously declared field in the same literal or type.

## Exemplos

O código a seguir produz este diagnóstico porque the record literal has
two fields named `a`:

```dart
var r = (a: 1, [!a!]: 2);
```

O código a seguir produz este diagnóstico porque the record type
annotation has two fields named `a`, one a positional field and the other
a named field:

```dart
void f((int a, {int [!a!]}) r) {}
```

## Correções comuns

Rename one or both of the fields:

```dart
var r = (a: 1, b: 2);
```
