---
title: subtype_of_ffi_class
description: >-
  Details about the subtype_of_ffi_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' can't extend '{1}'._

_The class '{0}' can't implement '{1}'._

_The class '{0}' can't mix in '{1}'._

## Descrição

O analisador produz este diagnóstico quando a class extends any FFI class
other than `Struct` or `Union`, or implements or mixes in any FFI class.
`Struct` and `Union` are the only FFI classes that can be subtyped, and
then only by extending them.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` extends
`Double`:

```dart
import 'dart:ffi';

final class C extends [!Double!] {}
```

## Correções comuns

If the class should extend either `Struct` or `Union`, then change the
declaration of the class:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int i;
}
```

If the class shouldn't extend either `Struct` or `Union`, then remove any
references to FFI classes:

```dart
final class C {}
```

[ffi]: /interop/c-interop
