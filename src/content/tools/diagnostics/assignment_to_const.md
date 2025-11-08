---
title: assignment_to_const
description: >-
  Details about the assignment_to_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Constant variables can't be assigned a value after initialization._

## Descrição

O analisador produz este diagnóstico quando it finds an assignment to a
top-level variable, a static field, or a local variable that has the
`const` modifier. The value of a compile-time constant can't be changed at
runtime.

## Exemplo

O código a seguir produz este diagnóstico porque `c` is being assigned a
value even though it has the `const` modificador:

```dart
const c = 0;

void f() {
  [!c!] = 1;
  print(c);
}
```

## Correções comuns

If the variable must be assignable, then remove the `const` modificador:

```dart
var c = 0;

void f() {
  c = 1;
  print(c);
}
```

If the constant shouldn't be changed, then either remove the assignment or
use a local variable in place of references to the constant:

```dart
const c = 0;

void f() {
  var v = 1;
  print(v);
}
```
