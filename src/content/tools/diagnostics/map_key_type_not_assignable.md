---
title: map_key_type_not_assignable
description: >-
  Details about the map_key_type_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The element type '{0}' can't be assigned to the map key type '{1}'._

## Descrição

O analisador produz este diagnóstico quando a key of a key-value pair in a
map literal has a type that isn't assignable to the key type of the map.

## Exemplo

O código a seguir produz este diagnóstico porque `2` is an `int`, but
the keys of the map are required to be `String`s:

```dart
var m = <String, String>{[!2!] : 'a'};
```

## Correções comuns

If the type of the map is correct, then change the key to have the correct
type:

```dart
var m = <String, String>{'2' : 'a'};
```

If the type of the key is correct, then change the key type of the map:

```dart
var m = <int, String>{2 : 'a'};
```
