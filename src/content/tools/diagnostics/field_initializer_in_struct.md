---
title: field_initializer_in_struct
description: >-
  Details about the field_initializer_in_struct
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Constructors in subclasses of 'Struct' and 'Union' can't have field initializers._

## Descrição

O analisador produz este diagnóstico quando a constructor in a subclass of
either `Struct` or `Union` has one or more field initializers.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` has a
constructor with an initializer for the field `f`:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  int f;

  C() : [!f = 0!];
}
```

## Correções comuns

Remove the field initializer:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  int f;

  C();
}
```

[ffi]: /interop/c-interop
