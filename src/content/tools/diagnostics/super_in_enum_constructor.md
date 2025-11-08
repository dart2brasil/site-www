---
title: super_in_enum_constructor
description: >-
  Details about the super_in_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The enum constructor can't have a 'super' initializer._

## Descrição

O analisador produz este diagnóstico quando the initializer list in a
constructor in an enum contains an invocation of a super constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor in
the enum `E` has a super constructor invocation in the initializer list:

```dart
enum E {
  e;

  const E() : [!super!]();
}
```

## Correções comuns

Remove the super constructor invocation:

```dart
enum E {
  e;

  const E();
}
```
