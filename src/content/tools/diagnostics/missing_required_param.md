---
title: missing_required_param
description: >-
  Details about the missing_required_param
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The parameter '{0}' is required._

_The parameter '{0}' is required. {1}._

## Descrição

O analisador produz este diagnóstico quando a method or function with a
named parameter that is annotated as being required is invoked without
providing a value for the parameter.

## Exemplo

O código a seguir produz este diagnóstico porque the named parameter `x`
is required:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  [!f!]();
}
```

## Correções comuns

Provide the required value:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  f(x: 2);
}
```
