---
title: division_optimization
description: >-
  Details about the division_optimization
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The operator x ~/ y is more efficient than (x / y).toInt()._

## Descrição

O analisador produz este diagnóstico quando the result of dividing two
numbers is converted to an integer using `toInt`. Dart has a built-in
integer division operator that is both more efficient and more concise.

## Exemplo

O código a seguir produz este diagnóstico porque the result of dividing
`x` and `y` is converted to an integer using `toInt`:

```dart
int divide(int x, int y) => [!(x / y).toInt()!];
```

## Correções comuns

Use the integer division operator (`~/`):

```dart
int divide(int x, int y) => x ~/ y;
```
