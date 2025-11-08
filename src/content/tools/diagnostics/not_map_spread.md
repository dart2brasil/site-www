---
ia-translate: true
title: not_map_spread
description: "Detalhes sobre o diagnóstico not_map_spread produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Spread elements in map literals must implement 'Map'._

## Description

O analisador produz este diagnóstico quando o tipo estático da
expressão de um elemento spread que aparece em um literal de map não
implementa o tipo `Map`.

## Example

O código a seguir produz este diagnóstico porque `l` não é um `Map`:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...[!l!]};
```

## Common fixes

A correção mais comum é substituir a expressão por uma que produza um
map:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...l.asMap()};
```
