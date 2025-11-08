---
title: annotation_on_pointer_field
description: >-
  Details about the annotation_on_pointer_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Fields in a struct class whose type is 'Pointer' shouldn't have any annotations._

## Descrição

O analisador produz este diagnóstico quando a field that's declared in a
subclass of `Struct` and has the type `Pointer` also has an annotation
associated with it.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the field `p`, which
has the type `Pointer` and is declared in a subclass of `Struct`, has the
annotation `@Double()`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external Pointer<Int8> p;
}
```

## Correções comuns

Remove the annotations from the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  external Pointer<Int8> p;
}
```

[ffi]: /interop/c-interop
