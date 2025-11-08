---
ia-translate: true
title: non_constant_relational_pattern_expression
description: >-
  Detalhes sobre o diagnóstico non_constant_relational_pattern_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The relational pattern expression must be a constant._

## Description

O analisador produz este diagnóstico quando o valor em uma expressão de
pattern relacional não é uma expressão constante.

## Example

O código a seguir produz este diagnóstico porque o operando do operador `>`,
`a`, não é uma constante:

```dart
final a = 0;

void f(int x) {
  if (x case > [!a!]) {}
}
```

## Common fixes

Substitua o valor por uma expressão constante:

```dart
const a = 0;

void f(int x) {
  if (x case > a) {}
}
```
