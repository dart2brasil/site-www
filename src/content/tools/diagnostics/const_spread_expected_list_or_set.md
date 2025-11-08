---
title: const_spread_expected_list_or_set
description: >-
  Details about the const_spread_expected_list_or_set
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A list or a set is expected in this spread._

## Descrição

O analisador produz este diagnóstico quando the expression of a spread
operator in a constant list or set evaluates to something other than a list
or a set.

## Exemplo

O código a seguir produz este diagnóstico porque the value of `list1` is
`null`, which is neither a list nor a set:

```dart
const dynamic list1 = 42;
const List<int> list2 = [...[!list1!]];
```

## Correções comuns

Change the expression to something that evaluates to either a constant list
or a constant set:

```dart
const dynamic list1 = [42];
const List<int> list2 = [...list1];
```
