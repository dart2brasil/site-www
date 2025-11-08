---
ia-translate: true
title: invalid_exception_value
description: "Detalhes sobre o diagnóstico invalid_exception_value produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O método {0} não pode ter um valor de retorno excepcional (o segundo argumento) quando o tipo de retorno da função é 'void', 'Handle' ou 'Pointer'._

## Description

O analisador produz este diagnóstico quando uma invocação do método
`Pointer.fromFunction` ou `NativeCallable.isolateLocal` tem um segundo
argumento (o valor de retorno excepcional) e o tipo a ser retornado da
invocação é `void`, `Handle` ou `Pointer`.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque um segundo argumento é
fornecido quando o tipo de retorno de `f` é `void`:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f, [!42!]);
}
```

## Common fixes

Remova o valor de exceção:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f);
}
```

[ffi]: /interop/c-interop
