---
title: record_literal_one_positional_no_trailing_comma
description: >-
  Details about the record_literal_one_positional_no_trailing_comma
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A record literal with exactly one positional field requires a trailing comma._

## Descrição

O analisador produz este diagnóstico quando a record literal with a single
positional field doesn't have a trailing comma after the field.

In some locations a record literal with a single positional field could
also be a parenthesized expression. A trailing comma is required to
disambiguate these two valid interpretations.

## Exemplo

O código a seguir produz este diagnóstico porque the record literal has
one positional field but doesn't have a trailing comma:

```dart
var r = const (1[!)!];
```

## Correções comuns

Add a trailing comma:

```dart
var r = const (1,);
```
