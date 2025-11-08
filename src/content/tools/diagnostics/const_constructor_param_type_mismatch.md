---
title: const_constructor_param_type_mismatch
description: >-
  Details about the const_constructor_param_type_mismatch
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A value of type '{0}' can't be assigned to a parameter of type '{1}' in a const constructor._

## Descrição

O analisador produz este diagnóstico quando the runtime type of a constant
value can't be assigned to the static type of a constant constructor's
parameter.

## Exemplo

O código a seguir produz este diagnóstico porque the runtime type of `i`
is `int`, which can't be assigned to the static type of `s`:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C([!i!]);
}
```

## Correções comuns

Pass a value of the correct type to the construtor:

```dart
class C {
  final String s;

  const C(this.s);
}

const dynamic i = 0;

void f() {
  const C('$i');
}
```
