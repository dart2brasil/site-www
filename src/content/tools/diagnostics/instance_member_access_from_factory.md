---
title: instance_member_access_from_factory
description: >-
  Details about the instance_member_access_from_factory
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Instance members can't be accessed from a factory constructor._

## Descrição

O analisador produz este diagnóstico quando a factory constructor contains
an unqualified reference to an instance member. In a generative
constructor, the instance of the class is created and initialized before
the body of the constructor is executed, so the instance can be bound to
`this` and accessed just like it would be in an instance method. But, in a
factory constructor, the instance isn't created before executing the body,
so `this` can't be used to reference it.

## Exemplo

O código a seguir produz este diagnóstico porque `x` isn't in scope in
the factory construtor:

```dart
class C {
  int x;
  factory C() {
    return C._([!x!]);
  }
  C._(this.x);
}
```

## Correções comuns

Rewrite the code so that it doesn't reference the instance member:

```dart
class C {
  int x;
  factory C() {
    return C._(0);
  }
  C._(this.x);
}
```
