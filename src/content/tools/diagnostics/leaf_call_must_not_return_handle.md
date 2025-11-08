---
ia-translate: true
title: leaf_call_must_not_return_handle
description: "Detalhes sobre o diagnóstico leaf_call_must_not_return_handle produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Chamada FFI leaf não pode retornar um 'Handle'._

## Description

O analisador produz este diagnóstico quando o valor do argumento `isLeaf`
em uma invocação de `Pointer.asFunction` ou
`DynamicLibrary.lookupFunction` é `true` e a função que seria
retornada teria um tipo de retorno `Handle`.

O analisador também produz este diagnóstico quando o valor do argumento `isLeaf`
em uma anotação `Native` é `true` e o argumento de tipo na
anotação é um tipo de função cujo tipo de retorno é `Handle`.

Em todos esses casos, chamadas leaf são suportadas apenas para os tipos `bool`,
`int`, `float`, `double`, e, como tipo de retorno `void`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a função `p`
retorna um `Handle`, mas o argumento `isLeaf` é `true`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Handle Function()>> p) {
  p.[!asFunction!]<Object Function()>(isLeaf: true);
}
```

## Common fixes

Se a função retorna um handle, então remova o argumento `isLeaf`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Handle Function()>> p) {
  p.asFunction<Object Function()>();
}
```

Se a função retorna um dos tipos suportados, então corrija a informação de
tipo:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Int32 Function()>> p) {
  p.asFunction<int Function()>(isLeaf: true);
}
```

[ffi]: /interop/c-interop
