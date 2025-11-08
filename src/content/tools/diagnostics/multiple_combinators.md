---
title: multiple_combinators
description: >-
  Details about the multiple_combinators
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Using multiple 'hide' or 'show' combinators is never necessary and often produces surprising results._

## Descrição

O analisador produz este diagnóstico quando an import or export directive
contains more than one combinator.

## Exemplos

O código a seguir produz este diagnóstico porque the second `show`
combinator hides `List` and `int`:

```dart
import 'dart:core' [!show Future, List, int show Future!];

var x = Future.value(1);
```

O código a seguir produz este diagnóstico porque
the second `hide` combinator is redundant:

```dart
import 'dart:math' [!hide Random, max, min hide min!];

var x = pi;
```

The following codes produce this diagnostic because
the `hide` combinator is redundant:

```dart
import 'dart:math' [!show Random, max hide min!];

var x = max(0, 1);
var r = Random();
```

O código a seguir produz este diagnóstico porque
the `show` combinator already hides `Random` and `max`,
so the `hide` combinator is redundant:

```dart
import 'dart:math' [!hide Random, max show min!];

var x = min(0, 1);
```

## Correções comuns

If you prefer to list the names that should be visible,
then use a single `show` combinator:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```

If you prefer to list the names that should be hidden,
then use a single `hide` combinator:

```dart
import 'dart:math' hide Random, max, min;

var x = pi;
```
