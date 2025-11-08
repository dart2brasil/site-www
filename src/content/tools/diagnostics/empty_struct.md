---
title: empty_struct
description: >-
  Details about the empty_struct
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' can't be empty because it's a subclass of '{1}'._

## Descrição

O analisador produz este diagnóstico quando a subclass of `Struct` or
`Union` não tem umay fields. Having an empty `Struct` or `Union`
isn't supported.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C`, which
extends `Struct`, doesn't declare any fields:

```dart
import 'dart:ffi';

final class [!C!] extends Struct {}
```

## Correções comuns

If the class is intended to be a struct, then declare one or more fields:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

If the class is intended to be used as a type argument to `Pointer`, then
make it a subclass of `Opaque`:

```dart
import 'dart:ffi';

final class C extends Opaque {}
```

If the class isn't intended to be a struct, then remove or change the
extends clause:

```dart
class C {}
```

[ffi]: /interop/c-interop
