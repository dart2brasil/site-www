---
title: undefined_constructor_in_initializer
description: >-
  Details about the undefined_constructor_in_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' doesn't have a constructor named '{1}'._

_The class '{0}' doesn't have an unnamed constructor._

## Descrição

O analisador produz este diagnóstico quando a superclass constructor is
invoked in the initializer list of a constructor, but the superclass
doesn't define the constructor being invoked.

## Exemplos

O código a seguir produz este diagnóstico porque `A` não tem uma
unnamed construtor:

```dart
class A {
  A.n();
}
class B extends A {
  B() : [!super()!];
}
```

O código a seguir produz este diagnóstico porque `A` doesn't have a
constructor named `m`:

```dart
class A {
  A.n();
}
class B extends A {
  B() : [!super.m()!];
}
```

## Correções comuns

If the superclass defines a constructor that should be invoked, then change
the constructor being invoked:

```dart
class A {
  A.n();
}
class B extends A {
  B() : super.n();
}
```

If the superclass doesn't define an appropriate constructor, then define
the constructor being invoked:

```dart
class A {
  A.m();
  A.n();
}
class B extends A {
  B() : super.m();
}
```
