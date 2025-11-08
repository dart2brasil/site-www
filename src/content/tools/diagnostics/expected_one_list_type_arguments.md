---
title: expected_one_list_type_arguments
description: >-
  Details about the expected_one_list_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_List literals require one type argument or none, but {0} found._

## Descrição

O analisador produz este diagnóstico quando a list literal tem mais de uma
type argument.

## Exemplo

O código a seguir produz este diagnóstico porque the list literal has
two type arguments when it can have at most one:

```dart
var l = [!<int, int>!][];
```

## Correções comuns

Remove all except one of the type arguments:

```dart
var l = <int>[];
```
