---
title: abstract_super_member_reference
description: >-
  Details about the abstract_super_member_reference
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The {0} '{1}' is always abstract in the supertype._

## Descrição

O analisador produz este diagnóstico quando um membro herdado é
referenced using `super`, but there is no concrete implementation of the
member in the superclass chain. Abstract members can't be invoked.

## Exemplo

O código a seguir produz este diagnóstico porque `B` doesn't inherit a
concrete implementation of `a`:

```dart
abstract class A {
  int get a;
}
class B extends A {
  int get a => super.[!a!];
}
```

## Correções comuns

Remova a invocação do membro abstrato, possivelmente substituindo-a por uma
invocation of a concrete member.
