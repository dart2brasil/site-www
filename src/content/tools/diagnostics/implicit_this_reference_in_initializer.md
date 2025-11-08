---
title: implicit_this_reference_in_initializer
description: >-
  Details about the implicit_this_reference_in_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The instance member '{0}' can't be accessed in an initializer._

## Descrição

O analisador produz este diagnóstico quando it finds a reference to an
instance member in a constructor's initializer list.

## Exemplo

O código a seguir produz este diagnóstico porque `defaultX` is an
instance member:

```dart
class C {
  int x;

  C() : x = [!defaultX!];

  int get defaultX => 0;
}
```

## Correções comuns

If the member can be made static, then do so:

```dart
class C {
  int x;

  C() : x = defaultX;

  static int get defaultX => 0;
}
```

If not, then replace the reference in the initializer with a different
expression that doesn't use an instance member:

```dart
class C {
  int x;

  C() : x = 0;

  int get defaultX => 0;
}
```
