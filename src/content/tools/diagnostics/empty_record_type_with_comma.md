---
title: empty_record_type_with_comma
description: >-
  Details about the empty_record_type_with_comma
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A record type without fields can't have a trailing comma._

## Descrição

O analisador produz este diagnóstico quando a record type that has no
fields has a trailing comma. Empty record types can't contain a comma.

## Exemplo

O código a seguir produz este diagnóstico porque the empty record type
has a trailing comma:

```dart
void f(([!,!]) r) {}
```

## Correções comuns

If the record type is intended to be empty, then remove the comma:

```dart
void f(() r) {}
```

If the record type is intended to have one or more fields, then add the
types of those fields:

```dart
void f((int, int) r) {}
```
