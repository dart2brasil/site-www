---
title: field_must_be_external_in_struct
description: >-
  Details about the field_must_be_external_in_struct
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Fields of 'Struct' and 'Union' subclasses must be marked external._

## Descrição

O analisador produz este diagnóstico quando a field in a subclass of either
`Struct` or `Union` isn't marked as being `external`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the field `a` isn't
marked as being `external`:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  int [!a!];
}
```

## Correções comuns

Add the required `external` modificador:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  external int a;
}
```

[ffi]: /interop/c-interop
