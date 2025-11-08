---
title: expected_one_set_type_arguments
description: >-
  Details about the expected_one_set_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Set literals require one type argument or none, but {0} were found._

## Descrição

O analisador produz este diagnóstico quando a set literal tem mais de uma
type argument.

## Exemplo

O código a seguir produz este diagnóstico porque the set literal has
three type arguments when it can have at most one:

```dart
var s = [!<int, String, int>!]{0, 'a', 1};
```

## Correções comuns

Remove all except one of the type arguments:

```dart
var s = <int>{0, 1};
```
