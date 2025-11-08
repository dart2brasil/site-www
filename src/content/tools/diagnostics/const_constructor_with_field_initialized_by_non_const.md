---
title: const_constructor_with_field_initialized_by_non_const
description: >-
  Details about the const_constructor_with_field_initialized_by_non_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Can't define the 'const' constructor because the field '{0}' is initialized with a non-constant value._

## Descrição

O analisador produz este diagnóstico quando a constructor has the keyword
`const`, but a field in the class is initialized to a non-constant value.

## Exemplo

O código a seguir produz este diagnóstico porque the field `s` is
initialized to a non-constant value:

```dart
String x = '3';
class C {
  final String s = x;
  [!const!] C();
}
```

## Correções comuns

If the field can be initialized to a constant value, then change the
initializer to a constant expression:

```dart
class C {
  final String s = '3';
  const C();
}
```

If the field can't be initialized to a constant value, then remove the
keyword `const` from the construtor:

```dart
String x = '3';
class C {
  final String s = x;
  C();
}
```
