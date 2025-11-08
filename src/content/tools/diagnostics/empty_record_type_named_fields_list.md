---
title: empty_record_type_named_fields_list
description: >-
  Details about the empty_record_type_named_fields_list
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The list of named fields in a record type can't be empty._

## Descrição

O analisador produz este diagnóstico quando a record type has an empty list
of named fields.

## Exemplo

O código a seguir produz este diagnóstico porque the record type has an
empty list of named fields:

```dart
void f((int, int, {[!}!]) r) {}
```

## Correções comuns

If the record is intended to have named fields, then add the types and
names of the fields:

```dart
void f((int, int, {int z}) r) {}
```

If the record isn't intended to have named fields, then remove the curly
braces:

```dart
void f((int, int) r) {}
```
