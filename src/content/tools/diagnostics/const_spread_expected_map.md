---
title: const_spread_expected_map
description: >-
  Details about the const_spread_expected_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A map is expected in this spread._

## Descrição

O analisador produz este diagnóstico quando the expression of a spread
operator in a constant map evaluates to something other than a map.

## Exemplo

O código a seguir produz este diagnóstico porque the value of `map1` is
`null`, which isn't a map:

```dart
const dynamic map1 = 42;
const Map<String, int> map2 = {...[!map1!]};
```

## Correções comuns

Change the expression to something that evaluates to a constant map:

```dart
const dynamic map1 = {'answer': 42};
const Map<String, int> map2 = {...map1};
```
