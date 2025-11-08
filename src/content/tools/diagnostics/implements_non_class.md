---
title: implements_non_class
description: >-
  Details about the implements_non_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes and mixins can only implement other classes and mixins._

## Descrição

O analisador produz este diagnóstico quando a name used in the `implements`
clause of a class or mixin declaration is defined to be something other
than a class or mixin.

## Exemplo

O código a seguir produz este diagnóstico porque `x` is a variable
rather than a class or mixin:

```dart
var x;
class C implements [!x!] {}
```

## Correções comuns

If the name is the name of an existing class or mixin that's already being
imported, then add a prefix to the import so that the local definition of
the name doesn't shadow the imported name.

If the name is the name of an existing class or mixin that isn't being
imported, then add an import, with a prefix, for the library in which it's
declared.

Otherwise, either replace the name in the `implements` clause with the name
of an existing class or mixin, or remove the name from the `implements`
clause.
