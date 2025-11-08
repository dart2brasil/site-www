---
title: empty_record_literal_with_comma
description: >-
  Details about the empty_record_literal_with_comma
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A record literal without fields can't have a trailing comma._

## Descrição

O analisador produz este diagnóstico quando a record literal that has no
fields has a trailing comma. Empty record literals can't contain a comma.

## Exemplo

O código a seguir produz este diagnóstico porque the empty record
literal has a trailing comma:

```dart
var r = ([!,!]);
```

## Correções comuns

If the record is intended to be empty, then remove the comma:

```dart
var r = ();
```

If the record is intended to have one or more fields, then add the
expressions used to compute the values of those fields:

```dart
var r = (3, 4);
```
