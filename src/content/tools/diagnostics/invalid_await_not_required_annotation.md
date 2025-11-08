---
title: invalid_await_not_required_annotation
description: >-
  Details about the invalid_await_not_required_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation 'awaitNotRequired' can only be applied to a Future-returning function, or a Future-typed field._

## Descrição

O analisador produz este diagnóstico quando anything other than a
`Future`-returning function or a `Future`-typed field or top-level
variable is annotated with [`awaitNotRequired`][meta-awaitNotRequired].

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
`void`-returning function:

```dart
import 'package:meta/meta.dart';

@[!awaitNotRequired!]
void f() {}
```

## Correções comuns

Remove the annotation:

```dart
void f() {}
```

[meta-awaitNotRequired]: https://pub.dev/documentation/meta/latest/meta/awaitNotRequired-constant.html
