---
title: non_type_as_type_argument
description: >-
  Details about the non_type_as_type_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' isn't a type, so it can't be used as a type argument._

## Descrição

O analisador produz este diagnóstico quando an identifier that isn't a type
is used as a type argument.

## Exemplo

O código a seguir produz este diagnóstico porque `x` is a variable, not
a type:

```dart
var x = 0;
List<[!x!]> xList = [];
```

## Correções comuns

Change the type argument to be a type:

```dart
var x = 0;
List<int> xList = [];
```
