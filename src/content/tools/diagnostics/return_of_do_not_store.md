---
title: return_of_do_not_store
description: >-
  Details about the return_of_do_not_store
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' is annotated with 'doNotStore' and shouldn't be returned unless '{1}' is also annotated._

## Descrição

O analisador produz este diagnóstico quando a value that is annotated with
the [`doNotStore`][meta-doNotStore] annotation is returned from a method,
getter, or function that doesn't have the same annotation.

## Exemplo

O código a seguir produz este diagnóstico porque the result of invoking
`f` shouldn't be stored, but the function `g` isn't annotated to preserve
that semantic:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

int g() => [!f()!];
```

## Correções comuns

If the value that shouldn't be stored is the correct value to return, then
mark the function with the [`doNotStore`][meta-doNotStore] annotation:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

@doNotStore
int g() => f();
```

Otherwise, return a different value from the function:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

int g() => 0;
```

[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
