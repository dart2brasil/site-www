---
title: redirect_to_missing_constructor
description: >-
  Details about the redirect_to_missing_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The constructor '{0}' couldn't be found in '{1}'._

## Descrição

O analisador produz este diagnóstico quando a constructor redirects to a
constructor that doesn't exist.

## Exemplo

O código a seguir produz este diagnóstico porque the factory
constructor in `A` redirects to a constructor in `B` that doesn't exist:

```dart
class A {
  factory A() = [!B.name!];
}

class B implements A {
  B();
}
```

## Correções comuns

If the constructor being redirected to is correct, then define the
constructor:

```dart
class A {
  factory A() = B.name;
}

class B implements A {
  B();
  B.name();
}
```

If a different constructor should be invoked, then update the redirect:

```dart
class A {
  factory A() = B;
}

class B implements A {
  B();
}
```
