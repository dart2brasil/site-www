---
title: inconsistent_inheritance
description: >-
  Details about the inconsistent_inheritance
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Superinterfaces don't have a valid override for '{0}': {1}._

## Descrição

O analisador produz este diagnóstico quando a class inherits two or more
conflicting signatures for a member and doesn't provide an implementation
that satisfies all the inherited signatures.

## Exemplo

O código a seguir produz este diagnóstico porque `C` is inheriting the
declaration of `m` from `A`, and that implementation isn't consistent with
the signature of `m` that's inherited from `B`:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class [!C!] extends A implements B {
}
```

## Correções comuns

Adicione uma implementation of the method that satisfies all the inherited
signatures:

```dart
class A {
  void m({int? a}) {}
}

class B {
  void m({int? b}) {}
}

class C extends A implements B {
  void m({int? a, int? b}) {}
}
```
