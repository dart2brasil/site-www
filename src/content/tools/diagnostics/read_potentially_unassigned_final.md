---
title: read_potentially_unassigned_final
description: >-
  Details about the read_potentially_unassigned_final
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The final variable '{0}' can't be read because it's potentially unassigned at this point._

## Descrição

O analisador produz este diagnóstico quando a final local variable that
isn't initialized at the declaration site is read at a point where the
compiler can't prove that the variable is always initialized before it's
referenced.

## Exemplo

O código a seguir produz este diagnóstico porque the final local
variable `x` is read (on line 3) when it's possible that it hasn't yet
been initialized:

```dart
int f() {
  final int x;
  return [!x!];
}
```

## Correções comuns

Ensure that the variable has been initialized before it's read:

```dart
int f(bool b) {
  final int x;
  if (b) {
    x = 0;
  } else {
    x = 1;
  }
  return x;
}
```
