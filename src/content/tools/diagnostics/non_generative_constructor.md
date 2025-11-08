---
title: non_generative_constructor
description: >-
  Details about the non_generative_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The generative constructor '{0}' is expected, but a factory was found._

## Descrição

O analisador produz este diagnóstico quando the initializer list of a
constructor invokes a constructor from the superclass, and the invoked
constructor is a factory constructor. Only a generative constructor can be
invoked in the initializer list.

## Exemplo

O código a seguir produz este diagnóstico porque the invocation of the
constructor `super.one()` is invoking a factory construtor:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : [!super.one()!];
}
```

## Correções comuns

Change the super invocation to invoke a generative construtor:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : super.two();
}
```

If the generative constructor is the unnamed constructor, and if there are
no arguments being passed to it, then you can remove the super invocation.
