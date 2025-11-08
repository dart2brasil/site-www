---
title: creation_with_non_type
description: >-
  Details about the creation_with_non_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' isn't a class._

## Descrição

O analisador produz este diagnóstico quando an instance creation using
either `new` or `const` specifies a name that isn't defined as a class.

## Exemplo

O código a seguir produz este diagnóstico porque `f` is a function
rather than a class:

```dart
int f() => 0;

void g() {
  new [!f!]();
}
```

## Correções comuns

If a class should be created, then replace the invalid name with the name
of a valid class:

```dart
int f() => 0;

void g() {
  new Object();
}
```

If the name is the name of a function and you want that function to be
invoked, then remove the `new` or `const` keyword:

```dart
int f() => 0;

void g() {
  f();
}
```
