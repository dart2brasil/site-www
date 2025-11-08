---
title: const_with_non_constant_argument
description: >-
  Details about the const_with_non_constant_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Arguments of a constant creation must be constant expressions._

## Descrição

O analisador produz este diagnóstico quando a const constructor is invoked
with an argument that isn't a constant expression.

## Exemplo

O código a seguir produz este diagnóstico porque `i` isn't a constant:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => const C([!i!]);
```

## Correções comuns

Either make all of the arguments constant expressions, or remove the
`const` keyword to use the non-constant form of the construtor:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => C(i);
```
