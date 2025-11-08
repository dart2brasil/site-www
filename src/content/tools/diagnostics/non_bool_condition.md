---
title: non_bool_condition
description: >-
  Details about the non_bool_condition
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Conditions must have a static type of 'bool'._

## Descrição

O analisador produz este diagnóstico quando a condition, such as an `if` or
`while` loop, doesn't have the static type `bool`.

## Exemplo

O código a seguir produz este diagnóstico porque `x` has the static type
`int`:

```dart
void f(int x) {
  if ([!x!]) {
    // ...
  }
}
```

## Correções comuns

Change the condition so that it produces a Boolean value:

```dart
void f(int x) {
  if (x == 0) {
    // ...
  }
}
```
