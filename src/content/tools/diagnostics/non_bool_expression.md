---
ia-translate: true
title: non_bool_expression
description: >-
  Detalhes sobre o diagnóstico non_bool_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The expression in an assert must be of type 'bool'._

## Description

O analisador produz este diagnóstico quando a primeira expressão em um
assert possui um tipo diferente de `bool`.

## Example

O código a seguir produz este diagnóstico porque o tipo de `p` é
`int`, mas um `bool` é necessário:

```dart
void f(int p) {
  assert([!p!]);
}
```

## Common fixes

Mude a expressão para que ela tenha o tipo `bool`:

```dart
void f(int p) {
  assert(p > 0);
}
```
