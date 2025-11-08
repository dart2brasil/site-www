---
title: non_nullable_equals_parameter
description: >-
  Details about the non_nullable_equals_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The parameter type of '==' operators should be non-nullable._

## Descrição

O analisador produz este diagnóstico quando an override of the operator
`==` has a parameter whose type is nullable. The language spec makes it
impossible for the argument of the method to be `null`, and the
parameter's type should reflect that.

## Exemplo

O código a seguir produz este diagnóstico porque the implementation of
the operator `==` in `C` :

```dart
class C {
  @override
  bool operator [!==!](Object? other) => false;
}
```

## Correções comuns

Make the parameter type be non-nullable:

```dart
class C {
  @override
  bool operator ==(Object other) => false;
}
```
