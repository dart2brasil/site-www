---
title: size_annotation_dimensions
description: >-
  Details about the size_annotation_dimensions
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'Array's must have an 'Array' annotation that matches the dimensions._

## Descrição

O analisador produz este diagnóstico quando the number of dimensions
specified in an `Array` annotation doesn't match the number of nested
arrays specified by the type of a field.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the field `a0` has a
type with three nested arrays, but only two dimensions are given in the
`Array` annotation:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Array(8, 8)!]
  external Array<Array<Array<Uint8>>> a0;
}
```

## Correções comuns

If the type of the field is correct, then fix the annotation to have the
required number of dimensions:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8, 8, 4)
  external Array<Array<Array<Uint8>>> a0;
}
```

If the type of the field is wrong, then fix the type of the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8, 8)
  external Array<Array<Uint8>> a0;
}
```

[ffi]: /interop/c-interop
