---
title: ffi_native_unexpected_number_of_parameters
description: >-
  Details about the ffi_native_unexpected_number_of_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Unexpected number of Native annotation parameters. Expected {0} but has {1}._

## Descrição

O analisador produz este diagnóstico quando the number of parameters in the
function type used as a type argument for the `@Native` annotation doesn't
match the number of parameters in the function being annotated.

## Exemplo

O código a seguir produz este diagnóstico porque the function type used
as a type argument for the `@Native` annotation (`Void Function(Double)`)
has one argument and the type of the annotated function
(`void f(double, double)`) has two arguments:

```dart
import 'dart:ffi';

@Native<Void Function(Double)>(symbol: 'f')
external void [!f!](double x, double y);
```

## Correções comuns

If the annotated function is correct, then update the function type in the
`@Native` annotation to match:

```dart
import 'dart:ffi';

@Native<Void Function(Double, Double)>(symbol: 'f')
external void f(double x, double y);
```

If the function type in the `@Native` annotation is correct, then update
the annotated function to match:

```dart
import 'dart:ffi';

@Native<Void Function(Double)>(symbol: 'f')
external void f(double x);
```
