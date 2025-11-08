---
title: external_with_initializer
description: >-
  Details about the external_with_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_External fields can't have initializers._

_External variables can't have initializers._

## Descrição

O analisador produz este diagnóstico quando a field or variable marked with
the keyword `external` has an initializer, or when an external field is
initialized in a constructor.

## Exemplos

O código a seguir produz este diagnóstico porque the external field `x`
is assigned a value in an initializer:

```dart
class C {
  external int x;
  C() : [!x!] = 0;
}
```

O código a seguir produz este diagnóstico porque the external field `x`
has an initializer:

```dart
class C {
  external final int [!x!] = 0;
}
```

O código a seguir produz este diagnóstico porque the external top level
variable `x` has an initializer:

```dart
external final int [!x!] = 0;
```

## Correções comuns

Remove the initializer:

```dart
class C {
  external final int x;
}
```
