---
title: ffi_native_invalid_multiple_annotations
description: >-
  Details about the ffi_native_invalid_multiple_annotations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Native functions and fields must have exactly one `@Native` annotation._

## Descrição

O analisador produz este diagnóstico quando there is more than one `Native`
annotation on a single declaration.

## Exemplo

O código a seguir produz este diagnóstico porque the function `f` has
two `Native` annotations associated with it:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>()
@[!Native!]<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```

## Correções comuns

Remove all but one of the annotations:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```
