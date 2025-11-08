---
title: non_native_function_type_argument_to_pointer
description: >-
  Details about the non_native_function_type_argument_to_pointer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Can't invoke 'asFunction' because the function signature '{0}' for the pointer isn't a valid C function signature._

## Descrição

O analisador produz este diagnóstico quando the method `asFunction` is
invoked on a pointer to a native function, but the signature of the native
function isn't a valid C function signature.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque function signature
associated with the pointer `p` (`FNative`) isn't a valid C function
signature:

```dart
import 'dart:ffi';

typedef FNative = int Function(int);
typedef F = int Function(int);

class C {
  void f(Pointer<NativeFunction<FNative>> p) {
    p.asFunction<[!F!]>();
  }
}
```

## Correções comuns

Make the `NativeFunction` signature a valid C signature:

```dart
import 'dart:ffi';

typedef FNative = Int8 Function(Int8);
typedef F = int Function(int);

class C {
  void f(Pointer<NativeFunction<FNative>> p) {
    p.asFunction<F>();
  }
}
```

[ffi]: /interop/c-interop
