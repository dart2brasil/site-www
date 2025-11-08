---
title: undefined_shown_name
description: >-
  Details about the undefined_shown_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The library '{0}' doesn't export a member with the shown name '{1}'._

## Descrição

O analisador produz este diagnóstico quando a show combinator includes a
name that isn't defined by the library being imported.

## Exemplo

O código a seguir produz este diagnóstico porque `dart:math` doesn't
define the name `String`:

```dart
import 'dart:math' show min, [!String!];

var x = min(0, 1);
```

## Correções comuns

If a different name should be shown, then correct the name. Otherwise,
remove the name from the list:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```
