---
ia-translate: true
title: non_native_function_type_argument_to_pointer
description: "Detalhes sobre o diagnóstico non_native_function_type_argument_to_pointer produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não é possível invocar 'asFunction' porque a assinatura da função '{0}' para o ponteiro não é uma assinatura de função C válida._

## Description

O analisador produz este diagnóstico quando o método `asFunction` é
invocado em um ponteiro para uma função nativa, mas a assinatura da função nativa
não é uma assinatura de função C válida.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a assinatura da função
associada ao ponteiro `p` (`FNative`) não é uma assinatura de função C
válida:

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

## Common fixes

Torne a assinatura `NativeFunction` uma assinatura C válida:

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
