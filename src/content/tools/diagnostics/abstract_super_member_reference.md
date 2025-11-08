---
ia-translate: true
title: abstract_super_member_reference
description: >-
  Detalhes sobre o diagnóstico abstract_super_member_reference
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The {0} '{1}' is always abstract in the supertype._

## Description

O analisador produz este diagnóstico quando um membro herdado é
referenciado usando `super`, mas não há implementação concreta do
membro na cadeia de superclasses. Membros abstract não podem ser invocados.

## Example

O código a seguir produz este diagnóstico porque `B` não herda uma
implementação concreta de `a`:

```dart
abstract class A {
  int get a;
}
class B extends A {
  int get a => super.[!a!];
}
```

## Common fixes

Remova a invocação do membro abstract, possivelmente substituindo-a por uma
invocação de um membro concreto.
