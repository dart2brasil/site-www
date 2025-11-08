---
title: redirect_to_abstract_class_constructor
description: >-
  Details about the redirect_to_abstract_class_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The redirecting constructor '{0}' can't redirect to a constructor of the abstract class '{1}'._

## Descrição

O analisador produz este diagnóstico quando a constructor redirects to a
constructor in an abstract class.

## Exemplo

O código a seguir produz este diagnóstico porque the factory
constructor in `A` redirects to a constructor in `B`, but `B` is an
abstract class:

```dart
class A {
  factory A() = [!B!];
}

abstract class B implements A {}
```

## Correções comuns

If the code redirects to the correct constructor, then change the class so
that it isn't abstract:

```dart
class A {
  factory A() = B;
}

class B implements A {}
```

Otherwise, change the factory constructor so that it either redirects to a
constructor in a concrete class, or has a concrete implementation.
