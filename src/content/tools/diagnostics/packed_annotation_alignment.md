---
title: packed_annotation_alignment
description: >-
  Details about the packed_annotation_alignment
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Only packing to 1, 2, 4, 8, and 16 bytes is supported._

## Descrição

O analisador produz este diagnóstico quando the argument to the `Packed`
annotation isn't one of the allowed values: 1, 2, 4, 8, or 16.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the argument to the
`Packed` annotation (`3`) isn't one of the allowed values:

```dart
import 'dart:ffi';

@Packed([!3!])
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

## Correções comuns

Change the alignment to be one of the allowed values:

```dart
import 'dart:ffi';

@Packed(4)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

[ffi]: /interop/c-interop
