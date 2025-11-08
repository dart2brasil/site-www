---
title: duplicate_hidden_name
description: >-
  Details about the duplicate_hidden_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Duplicate hidden name._

## Descrição

O analisador produz este diagnóstico quando a name occurs multiple times in
a `hide` clause. Repeating the name is unnecessary.

## Exemplo

O código a seguir produz este diagnóstico porque the name `min` is
hidden more than once:

```dart
import 'dart:math' hide min, [!min!];

var x = pi;
```

## Correções comuns

If the name was mistyped in one or more places, then correct the mistyped
names:

```dart
import 'dart:math' hide max, min;

var x = pi;
```

If the name wasn't mistyped, then remove the unnecessary name from the
list:

```dart
import 'dart:math' hide min;

var x = pi;
```
