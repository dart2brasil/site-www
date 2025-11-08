---
title: cast_to_non_type
description: >-
  Details about the cast_to_non_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' isn't a type, so it can't be used in an 'as' expression._

## Descrição

O analisador produz este diagnóstico quando the name following the `as` in a
cast expression is defined to be something other than a type.

## Exemplo

O código a seguir produz este diagnóstico porque `x` is a variable, not
a type:

```dart
num x = 0;
int y = x as [!x!];
```

## Correções comuns

Replace the name with the name of a type:

```dart
num x = 0;
int y = x as int;
```
