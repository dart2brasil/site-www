---
title: deprecated_subtype_of_function
description: >-
  Details about the deprecated_subtype_of_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extending 'Function' is deprecated._

_Implementing 'Function' has no effect._

_Mixing in 'Function' is deprecated._

## Descrição

O analisador produz este diagnóstico quando the class `Function` is used in
either the `extends`, `implements`, or `with` clause of a class or mixin.
Using the class `Function` in this way has no semantic value, so it's
effectively dead code.

## Exemplo

O código a seguir produz este diagnóstico porque `Function` is used as
the superclass of `F`:

```dart
class F extends [!Function!] {}
```

## Correções comuns

Remove the class `Function` from whichever clause it's in, and remove the
whole clause if `Function` is the only type in the clause:

```dart
class F {}
```
