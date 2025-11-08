---
title: extra_size_annotation_carray
description: >-
  Details about the extra_size_annotation_carray
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'Array's must have exactly one 'Array' annotation._

## Descrição

O analisador produz este diagnóstico quando a field in a subclass of
`Struct` tem mais de uma annotation describing the size of the native
array.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the field `a0` has two
annotations that specify the size of the native array:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(4)
  [!@Array(8)!]
  external Array<Uint8> a0;
}
```

## Correções comuns

Remove all but one of the annotations:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
