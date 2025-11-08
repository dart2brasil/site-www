---
title: missing_exception_value
description: >-
  Detalhes sobre o diagnóstico missing_exception_value
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O method {0} deve ter um valor de retorno excepcional (o segundo argumento) quando o tipo de retorno da função não é 'void', 'Handle' nem 'Pointer'._

## Description

O analisador produz este diagnóstico quando uma invocação do method
`Pointer.fromFunction` ou `NativeCallable.isolateLocal`
não tem um segundo argumento (o valor de retorno
excepcional) quando o tipo a ser retornado da invocação não é
`void`, `Handle` nem `Pointer`.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o tipo retornado por
`f` deve ser um inteiro de 8 bits, mas a chamada a `fromFunction`
não inclui um argumento de retorno excepcional:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  Pointer.[!fromFunction!]<Int8 Function(Int8)>(f);
}
```

## Common fixes

Adicione um tipo de retorno excepcional:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  Pointer.fromFunction<Int8 Function(Int8)>(f, 0);
}
```

[ffi]: /interop/c-interop
