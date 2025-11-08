---
title: disallowed_type_instantiation_expression
description: >-
  Details about the disallowed_type_instantiation_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Only a generic type, generic function, generic instance method, or generic constructor can have type arguments._

## Descrição

O analisador produz este diagnóstico quando an expression with a value that
is anything other than one of the allowed kinds of values is followed by
type arguments. The allowed kinds of values are:
- generic types,
- generic constructors, and
- generic functions, including top-level functions, static and instance
  members, and local functions.

## Exemplo

O código a seguir produz este diagnóstico porque `i` is a top-level
variable, which isn't one of the allowed cases:

```dart
int i = 1;

void f() {
  print([!i!]<int>);
}
```

## Correções comuns

If the referenced value is correct, then remove the type arguments:

```dart
int i = 1;

void f() {
  print(i);
}
```
