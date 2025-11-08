---
title: unqualified_reference_to_non_local_static_member
description: >-
  Details about the unqualified_reference_to_non_local_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Static members from supertypes must be qualified by the name of the defining type._

## Descrição

O analisador produz este diagnóstico quando code in one class references a
static member in a superclass without prefixing the member's name with the
name of the superclass. Static members can only be referenced without a
prefix in the class in which they're declared.

## Exemplo

O código a seguir produz este diagnóstico porque the static field `x` is
referenced in the getter `g` without prefixing it with the name of the
defining class:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => [!x!];
}
```

## Correções comuns

Prefix the name of the static member with the name of the declaring class:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => A.x;
}
```
