---
title: assignment_of_do_not_store
description: >-
  Details about the assignment_of_do_not_store
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' is marked 'doNotStore' and shouldn't be assigned to a field or top-level variable._

## Descrição

O analisador produz este diagnóstico quando the value of a function
(including methods and getters) that is explicitly or implicitly marked by
the [`doNotStore`][meta-doNotStore] annotation is stored in either a field
or top-level variable.

## Exemplo

O código a seguir produz este diagnóstico porque the value of the
function `f` is being stored in the top-level variable `x`:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 1;

var x = [!f()!];
```

## Correções comuns

Replace references to the field or variable with invocations of the
function producing the value.

[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
