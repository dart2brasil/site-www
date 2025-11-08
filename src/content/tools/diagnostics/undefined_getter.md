---
title: undefined_getter
description: >-
  Details about the undefined_getter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The getter '{0}' isn't defined for the '{1}' function type._

_The getter '{0}' isn't defined for the type '{1}'._

## Descrição

O analisador produz este diagnóstico quando it encounters an identifier that
appears to be the name of a getter but either isn't defined or isn't
visible in the scope in which it's being referenced.

## Exemplo

O código a seguir produz este diagnóstico porque `String` has no member
named `len`:

```dart
int f(String s) => s.[!len!];
```

## Correções comuns

If the identifier isn't defined, then either define it or replace it with
the name of a getter that is defined. The example above can be corrected by
fixing the spelling of the getter:

```dart
int f(String s) => s.length;
```
