---
title: non_bool_expression
description: >-
  Details about the non_bool_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The expression in an assert must be of type 'bool'._

## Descrição

O analisador produz este diagnóstico quando the first expression in an
assert has a type other than `bool`.

## Exemplo

O código a seguir produz este diagnóstico porque the type of `p` is
`int`, but a `bool` is required:

```dart
void f(int p) {
  assert([!p!]);
}
```

## Correções comuns

Change the expression so that it has the type `bool`:

```dart
void f(int p) {
  assert(p > 0);
}
```
