---
title: instance_access_to_static_member
description: >-
  Details about the instance_access_to_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The static {0} '{1}' can't be accessed through an instance._

## Descrição

O analisador produz este diagnóstico quando an access operator is used to
access a static member through an instance of the class.

## Exemplo

O código a seguir produz este diagnóstico porque `zero` is a static
field, but it's being accessed as if it were an instance field:

```dart
void f(C c) {
  c.[!zero!];
}

class C {
  static int zero = 0;
}
```

## Correções comuns

Use the class to access the static member:

```dart
void f(C c) {
  C.zero;
}

class C {
  static int zero = 0;
}
```
