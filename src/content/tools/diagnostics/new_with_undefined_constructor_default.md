---
title: new_with_undefined_constructor_default
description: >-
  Details about the new_with_undefined_constructor_default
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' doesn't have an unnamed constructor._

## Descrição

O analisador produz este diagnóstico quando an unnamed constructor is
invoked on a class that defines named constructors but the class doesn't
have an unnamed constructor.

## Exemplo

O código a seguir produz este diagnóstico porque `A` doesn't define an
unnamed construtor:

```dart
class A {
  A.a();
}

A f() => [!A!]();
```

## Correções comuns

If one of the named constructors does what you need, then use it:

```dart
class A {
  A.a();
}

A f() => A.a();
```

If none of the named constructors does what you need, and you're able to
add an unnamed constructor, then add the construtor:

```dart
class A {
  A();
  A.a();
}

A f() => A();
```
