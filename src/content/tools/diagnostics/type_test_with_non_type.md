---
title: type_test_with_non_type
description: >-
  Details about the type_test_with_non_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' isn't a type and can't be used in an 'is' expression._

## Descrição

O analisador produz este diagnóstico quando the right-hand side of an `is`
or `is!` test isn't a type.

## Exemplo

O código a seguir produz este diagnóstico porque the right-hand side is
a parameter, not a type:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is [!b!]) {
    return;
  }
}
```

## Correções comuns

If you intended to use a type test, then replace the right-hand side with a
type:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is B) {
    return;
  }
}
```

If you intended to use a different kind of test, then change the test:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a == b) {
    return;
  }
}
```
