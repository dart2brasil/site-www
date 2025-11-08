---
title: super_in_redirecting_constructor
description: >-
  Details about the super_in_redirecting_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The redirecting constructor can't have a 'super' initializer._

## Descrição

O analisador produz este diagnóstico quando a constructor that redirects to
another constructor also attempts to invoke a constructor from the
superclass. The superclass constructor will be invoked when the constructor
that the redirecting constructor is redirected to is invoked.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor `C.a`
both redirects to `C.b` and invokes a constructor from the superclass:

```dart
class C {
  C.a() : this.b(), [!super()!];
  C.b();
}
```

## Correções comuns

Remove the invocation of the `super` construtor:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```
