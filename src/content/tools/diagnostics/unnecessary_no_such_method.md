---
title: unnecessary_no_such_method
description: >-
  Details about the unnecessary_no_such_method
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Unnecessary 'noSuchMethod' declaration._

## Descrição

O analisador produz este diagnóstico quando there's a declaration of
`noSuchMethod`, the only thing the declaration does is invoke the
overridden declaration, and the overridden declaration isn't the
declaration in `Object`.

Overriding the implementation of `Object`'s `noSuchMethod` (no matter what
the implementation does) signals to the analyzer that it shouldn't flag any
inherited abstract methods that aren't implemented in that class. This
works even if the overriding implementation is inherited from a superclass,
so there's no value to declare it again in a subclass.

## Exemplo

O código a seguir produz este diagnóstico porque the declaration of
`noSuchMethod` in `A` makes the declaration of `noSuchMethod` in `B`
unnecessary:

```dart
class A {
  @override
  dynamic noSuchMethod(x) => super.noSuchMethod(x);
}
class B extends A {
  @override
  dynamic [!noSuchMethod!](y) {
    return super.noSuchMethod(y);
  }
}
```

## Correções comuns

Remove the unnecessary declaration:

```dart
class A {
  @override
  dynamic noSuchMethod(x) => super.noSuchMethod(x);
}
class B extends A {}
```
