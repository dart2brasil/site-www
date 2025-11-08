---
title: native_function_missing_type
description: >-
  Details about the native_function_missing_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The native type of this function couldn't be inferred so it must be specified in the annotation._

## Descrição

O analisador produz este diagnóstico quando a `@Native`-annotated function
requires a type hint on the annotation to infer the native function type.

Dart types like `int` and `double` have multiple possible native
representations. Since the native type needs to be known at compile time
to generate correct bindings and call instructions for the function, an
explicit type must be given.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque the function `f()` has
the return type `int`, but não tem uma explicit type parameter on the
`Native` annotation:

```dart
import 'dart:ffi';

@Native()
external int [!f!]();
```

## Correções comuns

Add the corresponding type to the annotation. For instance, if `f()` was
declared to return an `int32_t` in C, the Dart function should be declared
as:

```dart
import 'dart:ffi';

@Native<Int32 Function()>()
external int f();
```

[ffi]: /interop/c-interop
