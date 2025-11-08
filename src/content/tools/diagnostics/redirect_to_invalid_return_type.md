---
title: redirect_to_invalid_return_type
description: >-
  Details about the redirect_to_invalid_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The return type '{0}' of the redirected constructor isn't a subtype of '{1}'._

## Descrição

O analisador produz este diagnóstico quando a factory constructor redirects
to a constructor whose return type isn't a subtype of the type that the
factory constructor is declared to produce.

## Exemplo

O código a seguir produz este diagnóstico porque `A` isn't a subclass
of `C`, which means that the value returned by the constructor `A()`
couldn't be returned from the constructor `C()`:

```dart
class A {}

class B implements C {}

class C {
  factory C() = [!A!];
}
```

## Correções comuns

If the factory constructor is redirecting to a constructor in the wrong
class, then update the factory constructor to redirect to the correct
constructor:

```dart
class A {}

class B implements C {}

class C {
  factory C() = B;
}
```

If the class defining the constructor being redirected to is the class that
should be returned, then make it a subtype of the factory's return type:

```dart
class A implements C {}

class B implements C {}

class C {
  factory C() = A;
}
```
