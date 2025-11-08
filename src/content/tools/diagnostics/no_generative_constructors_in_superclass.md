---
title: no_generative_constructors_in_superclass
description: >-
  Details about the no_generative_constructors_in_superclass
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' can't extend '{1}' because '{1}' only has factory constructors (no generative constructors), and '{0}' has at least one generative constructor._

## Descrição

O analisador produz este diagnóstico quando a class that has at least one
generative constructor (whether explicit or implicit) has a superclass
that não tem umay generative constructors. Every generative
constructor, except the one defined in `Object`, invokes, either
explicitly or implicitly, one of the generative constructors from its
superclass.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `B` has an
implicit generative constructor that can't invoke a generative constructor
from `A` because `A` não tem umay generative construtores:

```dart
class A {
  factory A.none() => throw '';
}

class B extends [!A!] {}
```

## Correções comuns

If the superclass should have a generative constructor, then add one:

```dart
class A {
  A();
  factory A.none() => throw '';
}

class B extends A {}
```

If the subclass shouldn't have a generative constructor, then remove it by
adding a factory construtor:

```dart
class A {
  factory A.none() => throw '';
}

class B extends A {
  factory B.none() => throw '';
}
```

If the subclass must have a generative constructor but the superclass
can't have one, then implement the superclass instead:

```dart
class A {
  factory A.none() => throw '';
}

class B implements A {}
```
