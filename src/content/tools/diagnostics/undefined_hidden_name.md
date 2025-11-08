---
title: undefined_hidden_name
description: >-
  Details about the undefined_hidden_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The library '{0}' doesn't export a member with the hidden name '{1}'._

## Descrição

O analisador produz este diagnóstico quando a hide combinator includes a
name that isn't defined by the library being imported.

## Exemplo

O código a seguir produz este diagnóstico porque `dart:math` doesn't
define the name `String`:

```dart
import 'dart:math' hide [!String!], max;

var x = min(0, 1);
```

## Correções comuns

If a different name should be hidden, then correct the name. Otherwise,
remove the name from the list:

```dart
import 'dart:math' hide max;

var x = min(0, 1);
```
