---
title: non_abstract_class_inherits_abstract_member
description: >-
  Details about the non_abstract_class_inherits_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Missing concrete implementation of '{0}'._

_Missing concrete implementations of '{0}' and '{1}'._

_Missing concrete implementations of '{0}', '{1}', '{2}', '{3}', and {4} more._

_Missing concrete implementations of '{0}', '{1}', '{2}', and '{3}'._

_Missing concrete implementations of '{0}', '{1}', and '{2}'._

## Descrição

O analisador produz este diagnóstico quando a concrete class inherits one or
more abstract members, and doesn't provide or inherit an implementation for
at least one of those abstract members.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `B` doesn't
have a concrete implementation of `m`:

```dart
abstract class A {
  void m();
}

class [!B!] extends A {}
```

## Correções comuns

If the subclass can provide a concrete implementation for some or all of
the abstract inherited members, then add the concrete implementations:

```dart
abstract class A {
  void m();
}

class B extends A {
  void m() {}
}
```

If there is a mixin that provides an implementation of the inherited
methods, then apply the mixin to the subclass:

```dart
abstract class A {
  void m();
}

class B extends A with M {}

mixin M {
  void m() {}
}
```

If the subclass can't provide a concrete implementation for all of the
abstract inherited members, then mark the subclass as being abstract:

```dart
abstract class A {
  void m();
}

abstract class B extends A {}
```
