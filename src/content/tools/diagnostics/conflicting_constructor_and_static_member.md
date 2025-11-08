---
title: conflicting_constructor_and_static_member
description: >-
  Details about the conflicting_constructor_and_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' can't be used to name both a constructor and a static field in this class._

_'{0}' can't be used to name both a constructor and a static getter in this class._

_'{0}' can't be used to name both a constructor and a static method in this class._

_'{0}' can't be used to name both a constructor and a static setter in this class._

## Descrição

O analisador produz este diagnóstico quando a named constructor and either a
static method or static field have the same name. Both are accessed using
the name of the class, so having the same name makes the reference
ambiguous.

## Exemplos

O código a seguir produz este diagnóstico porque the static field `foo`
and the named constructor `foo` have the same name:

```dart
class C {
  C.[!foo!]();
  static int foo = 0;
}
```

O código a seguir produz este diagnóstico porque the static method `foo`
and the named constructor `foo` have the same name:

```dart
class C {
  C.[!foo!]();
  static void foo() {}
}
```

## Correções comuns

Rename either the member or the constructor.
