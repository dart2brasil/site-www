---
title: missing_required_param
description: >-
  Detalhes sobre o diagnóstico missing_required_param
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O parameter '{0}' é required._

_O parameter '{0}' é required. {1}._

## Description

O analisador produz este diagnóstico quando um method ou função com um
named parameter que está anotado como sendo required é invocado sem
fornecer um valor para o parameter.

## Example

O código a seguir produz este diagnóstico porque o named parameter `x`
é required:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  [!f!]();
}
```

## Common fixes

Forneça o valor required:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  f(x: 2);
}
```
