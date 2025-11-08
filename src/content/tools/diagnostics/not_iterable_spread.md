---
ia-translate: true
title: not_iterable_spread
description: >-
  Detalhes sobre o diagnóstico not_iterable_spread
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Spread elements in list or set literals must implement 'Iterable'._

## Description

O analisador produz este diagnóstico quando o tipo estático da
expressão de um elemento spread que aparece em um literal de lista ou um
literal de set não implementa o tipo `Iterable`.

## Example

O código a seguir produz este diagnóstico:

```dart
var m = <String, int>{'a': 0, 'b': 1};
var s = <String>{...[!m!]};
```

## Common fixes

A correção mais comum é substituir a expressão por uma que produza um
objeto iterável:

```dart
var m = <String, int>{'a': 0, 'b': 1};
var s = <String>{...m.keys};
```
