---
title: non_bool_negation_expression
description: >-
  Details about the non_bool_negation_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A negation operand must have a static type of 'bool'._

## Descrição

O analisador produz este diagnóstico quando the operand of the unary
negation operator (`!`) doesn't have the type `bool`.

## Exemplo

O código a seguir produz este diagnóstico porque `x` is an `int` when it
must be a `bool`:

```dart
int x = 0;
bool y = ![!x!];
```

## Correções comuns

Replace the operand with an expression that has the type `bool`:

```dart
int x = 0;
bool y = !(x > 0);
```
