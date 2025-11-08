---
title: field_in_struct_with_initializer
description: >-
  Details about the field_in_struct_with_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Fields in subclasses of 'Struct' and 'Union' can't have initializers._

## Descrição

O analisador produz este diagnóstico quando a field in a subclass of
`Struct` has an initializer.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the field `p` has an
initializer:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer [!p!] = nullptr;
}
```

## Correções comuns

Remove the initializer:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer p;
}
```

[ffi]: /interop/c-interop
