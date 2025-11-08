---
ia-translate: true
title: non_bool_negation_expression
description: >-
  Detalhes sobre o diagnóstico non_bool_negation_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A negation operand must have a static type of 'bool'._

## Description

O analisador produz este diagnóstico quando o operando do operador de
negação unário (`!`) não possui o tipo `bool`.

## Example

O código a seguir produz este diagnóstico porque `x` é um `int` quando deve
ser um `bool`:

```dart
int x = 0;
bool y = ![!x!];
```

## Common fixes

Substitua o operando por uma expressão que tenha o tipo `bool`:

```dart
int x = 0;
bool y = !(x > 0);
```
