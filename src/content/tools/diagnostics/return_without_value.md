---
title: return_without_value
description: >-
  Details about the return_without_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The return value is missing after 'return'._

## Descrição

O analisador produz este diagnóstico quando it finds a `return` statement
without an expression in a function that declares a return type.

## Exemplo

O código a seguir produz este diagnóstico porque the function `f` is
expected to return an `int`, but no value is being returned:

```dart
int f() {
  [!return!];
}
```

## Correções comuns

Adicione uma expression that computes the value to be returned:

```dart
int f() {
  return 0;
}
```
