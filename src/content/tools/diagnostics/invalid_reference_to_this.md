---
title: invalid_reference_to_this
description: >-
  Details about the invalid_reference_to_this
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Invalid reference to 'this' expression._

## Descrição

O analisador produz este diagnóstico quando `this` is used outside of an
instance method or a generative constructor. The reserved word `this` is
only defined in the context of an instance method, a generative
constructor, or the initializer of a late instance field declaration.

## Exemplo

O código a seguir produz este diagnóstico porque `v` is a top-level
variable:

```dart
C f() => [!this!];

class C {}
```

## Correções comuns

Use a variable of the appropriate type in place of `this`, declaring it if
necessary:

```dart
C f(C c) => c;

class C {}
```
