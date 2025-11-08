---
title: mixin_of_non_class
description: >-
  Details about the mixin_of_non_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes can only mix in mixins and classes._

## Descrição

O analisador produz este diagnóstico quando a name in a `with` clause is
defined to be something other than a mixin or a class.

## Exemplo

O código a seguir produz este diagnóstico porque `F` is defined to be a
function type:

```dart
typedef F = int Function(String);

class C with [!F!] {}
```

## Correções comuns

Remove the invalid name from the list, possibly replacing it with the name
of the intended mixin or class:

```dart
typedef F = int Function(String);

class C {}
```
