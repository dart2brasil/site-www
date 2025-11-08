---
title: switch_expression_not_assignable
description: >-
  Details about the switch_expression_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Type '{0}' of the switch expression isn't assignable to the type '{1}' of case expressions._

## Descrição

O analisador produz este diagnóstico quando the type of the expression in a
`switch` statement isn't assignable to the type of the expressions in the
`case` clauses.

## Exemplo

O código a seguir produz este diagnóstico porque the type of `s`
(`String`) isn't assignable to the type of `0` (`int`):

```dart
void f(String s) {
  switch ([!s!]) {
    case 0:
      break;
  }
}
```

## Correções comuns

If the type of the `case` expressions is correct, then change the
expression in the `switch` statement to have the correct type:

```dart
void f(String s) {
  switch (int.parse(s)) {
    case 0:
      break;
  }
}
```

If the type of the `switch` expression is correct, then change the `case`
expressions to have the correct type:

```dart
void f(String s) {
  switch (s) {
    case '0':
      break;
  }
}
```
