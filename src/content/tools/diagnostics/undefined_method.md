---
title: undefined_method
description: >-
  Details about the undefined_method
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The method '{0}' isn't defined for the '{1}' function type._

_The method '{0}' isn't defined for the type '{1}'._

## Descrição

O analisador produz este diagnóstico quando it encounters an identifier that
appears to be the name of a method but either isn't defined or isn't
visible in the scope in which it's being referenced.

## Exemplo

O código a seguir produz este diagnóstico porque the identifier
`removeMiddle` isn't defined:

```dart
int f(List<int> l) => l.[!removeMiddle!]();
```

## Correções comuns

If the identifier isn't defined, then either define it or replace it with
the name of a method that is defined. The example above can be corrected by
fixing the spelling of the method:

```dart
int f(List<int> l) => l.removeLast();
```
