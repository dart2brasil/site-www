---
title: unused_shown_name
description: >-
  Details about the unused_shown_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name {0} is shown, but isn't used._

## Descrição

O analisador produz este diagnóstico quando a show combinator includes a
name that isn't used within the library. Because it isn't referenced, the
name can be removed.

## Exemplo

O código a seguir produz este diagnóstico porque the function `max`
isn't used:

```dart
import 'dart:math' show min, [!max!];

var x = min(0, 1);
```

## Correções comuns

Either use the name or remove it:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```
