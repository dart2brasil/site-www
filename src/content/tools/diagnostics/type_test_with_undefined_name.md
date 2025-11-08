---
title: type_test_with_undefined_name
description: >-
  Details about the type_test_with_undefined_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' isn't defined, so it can't be used in an 'is' expression._

## Descrição

O analisador produz este diagnóstico quando the name following the `is` in a
type test expression isn't defined.

## Exemplo

O código a seguir produz este diagnóstico porque the name `Srting` isn't
defined:

```dart
void f(Object o) {
  if (o is [!Srting!]) {
    // ...
  }
}
```

## Correções comuns

Replace the name with the name of a type:

```dart
void f(Object o) {
  if (o is String) {
    // ...
  }
}
```
