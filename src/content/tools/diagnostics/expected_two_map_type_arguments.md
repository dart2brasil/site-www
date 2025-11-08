---
title: expected_two_map_type_arguments
description: >-
  Details about the expected_two_map_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Map literals require two type arguments or none, but {0} found._

## Descrição

O analisador produz este diagnóstico quando a map literal has either one or
more than two type arguments.

## Exemplo

O código a seguir produz este diagnóstico porque the map literal has
three type arguments when it can have either two or zero:

```dart
var m = [!<int, String, int>!]{};
```

## Correções comuns

Remove all except two of the type arguments:

```dart
var m = <int, String>{};
```
