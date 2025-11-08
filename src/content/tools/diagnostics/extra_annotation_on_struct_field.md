---
title: extra_annotation_on_struct_field
description: >-
  Details about the extra_annotation_on_struct_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Fields in a struct class must have exactly one annotation indicating the native type._

## Descrição

O analisador produz este diagnóstico quando a field in a subclass of
`Struct` tem mais de uma annotation describing the native type of the
field.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the field `x` has two
annotations describing the native type of the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  [!@Int16()!]
  external int x;
}
```

## Correções comuns

Remove all but one of the annotations:

```dart
import 'dart:ffi';
final class C extends Struct {
  @Int32()
  external int x;
}
```

[ffi]: /interop/c-interop
