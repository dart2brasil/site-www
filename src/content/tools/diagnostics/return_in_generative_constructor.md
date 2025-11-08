---
title: return_in_generative_constructor
description: >-
  Details about the return_in_generative_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Constructors can't return values._

## Descrição

O analisador produz este diagnóstico quando a generative constructor
contains a `return` statement that specifies a value to be returned.
Generative constructors always return the object that was created, and
therefore can't return a different object.

## Exemplo

O código a seguir produz este diagnóstico porque the `return` statement
has an expression:

```dart
class C {
  C() {
    return [!this!];
  }
}
```

## Correções comuns

If the constructor should create a new instance, then remove either the
`return` statement or the expression:

```dart
class C {
  C();
}
```

If the constructor shouldn't create a new instance, then convert it to be a
factory construtor:

```dart
class C {
  factory C() {
    return _instance;
  }

  static C _instance = C._();

  C._();
}
```
