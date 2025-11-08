---
title: invalid_exception_value
description: >-
  Details about the invalid_exception_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The method {0} can't have an exceptional return value (the second argument) when the return type of the function is either 'void', 'Handle' or 'Pointer'._

## Descrição

O analisador produz este diagnóstico quando an invocation of the method
`Pointer.fromFunction` or `NativeCallable.isolateLocal`
has a second argument (the exceptional return
value) and the type to be returned from the invocation is either `void`,
`Handle` or `Pointer`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a second argument is
provided when the return type of `f` is `void`:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f, [!42!]);
}
```

## Correções comuns

Remove the exception value:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f);
}
```

[ffi]: /interop/c-interop
