---
ia-translate: true
title: ffi_native_invalid_multiple_annotations
description: >-
  Detalhes sobre o diagnóstico ffi_native_invalid_multiple_annotations
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Funções e campos nativos devem ter exatamente uma anotação `@Native`._

## Description

O analisador produz este diagnóstico quando há mais de uma anotação `Native`
em uma única declaração.

## Example

O código a seguir produz este diagnóstico porque a função `f` tem
duas anotações `Native` associadas a ela:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>()
@[!Native!]<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```

## Common fixes

Remova todas as anotações, exceto uma:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```
