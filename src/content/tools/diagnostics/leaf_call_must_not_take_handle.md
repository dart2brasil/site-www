---
ia-translate: true
title: leaf_call_must_not_take_handle
description: "Detalhes sobre o diagnóstico leaf_call_must_not_take_handle produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Chamada FFI leaf não pode receber argumentos do tipo 'Handle'._

## Description

O analisador produz este diagnóstico quando o valor do argumento `isLeaf`
em uma invocação de `Pointer.asFunction` ou
`DynamicLibrary.lookupFunction` é `true` e a função que seria
retornada teria um parâmetro do tipo `Handle`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a função `p` tem um
parâmetro do tipo `Handle`, mas o argumento `isLeaf` é `true`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Handle)>> p) {
  p.[!asFunction!]<void Function(Object)>(isLeaf: true);
}
```

## Common fixes

Se a função tem pelo menos um parâmetro do tipo `Handle`, então remova
o argumento `isLeaf`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Handle)>> p) {
  p.asFunction<void Function(Object)>();
}
```

Se nenhum dos parâmetros da função são `Handle`s, então corrija a informação de
tipo:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Int8)>> p) {
  p.asFunction<void Function(int)>(isLeaf: true);
}
```

[ffi]: /interop/c-interop
