---
title: duplicate_named_argument
description: >-
  Details about the duplicate_named_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The argument for the named parameter '{0}' was already specified._

## Descrição

O analisador produz este diagnóstico quando an invocation has two or more
named arguments that have the same name.

## Exemplo

O código a seguir produz este diagnóstico porque há duas arguments
with the name `a`:

```dart
void f(C c) {
  c.m(a: 0, [!a!]: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

## Correções comuns

If one of the arguments should have a different name, then change the name:

```dart
void f(C c) {
  c.m(a: 0, b: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

If one of the arguments is wrong, then remove it:

```dart
void f(C c) {
  c.m(a: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```
