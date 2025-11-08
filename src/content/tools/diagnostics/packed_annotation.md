---
title: packed_annotation
description: >-
  Details about the packed_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Structs must have at most one 'Packed' annotation._

## Descrição

O analisador produz este diagnóstico quando a subclass of `Struct` has more
than one `Packed` annotation.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C`, which
is a subclass of `Struct`, has two `Packed` annotations:

```dart
import 'dart:ffi';

@Packed(1)
[!@Packed(1)!]
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

## Correções comuns

Remove all but one of the annotations:

```dart
import 'dart:ffi';

@Packed(1)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

[ffi]: /interop/c-interop
