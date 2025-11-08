---
title: not_map_spread
description: >-
  Details about the not_map_spread
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Spread elements in map literals must implement 'Map'._

## Descrição

O analisador produz este diagnóstico quando the static type of the
expression of a spread element that appears in a map literal doesn't
implement the type `Map`.

## Exemplo

O código a seguir produz este diagnóstico porque `l` isn't a `Map`:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...[!l!]};
```

## Correções comuns

The most common fix is to replace the expression with one that produces a
map:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...l.asMap()};
```
