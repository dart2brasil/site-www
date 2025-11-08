---
title: assignment_to_type
description: >-
  Details about the assignment_to_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Types can't be assigned a value._

## Descrição

O analisador produz este diagnóstico quando the name of a type name appears
on the left-hand side of an assignment expression.

## Exemplo

O código a seguir produz este diagnóstico porque the assignment to the
class `C` is invalid:

```dart
class C {}

void f() {
  [!C!] = null;
}
```

## Correções comuns

If the right-hand side should be assigned to something else, such as a
local variable, then change the left-hand side:

```dart
void f() {}

void g() {
  var c = null;
  print(c);
}
```
