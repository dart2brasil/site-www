---
ia-translate: true
title: non_bool_condition
description: >-
  Detalhes sobre o diagnóstico non_bool_condition
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Conditions must have a static type of 'bool'._

## Description

O analisador produz este diagnóstico quando uma condição, como em um `if` ou
loop `while`, não possui o tipo estático `bool`.

## Example

O código a seguir produz este diagnóstico porque `x` possui o tipo estático
`int`:

```dart
void f(int x) {
  if ([!x!]) {
    // ...
  }
}
```

## Common fixes

Mude a condição para que ela produza um valor Boolean:

```dart
void f(int x) {
  if (x == 0) {
    // ...
  }
}
```
