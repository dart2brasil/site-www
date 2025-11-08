---
ia-translate: true
title: argument_must_be_a_constant
description: >-
  Detalhes sobre o diagnóstico argument_must_be_a_constant
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Argument '{0}' must be a constant._

## Description

O analisador produz este diagnóstico quando uma invocação de
`Pointer.asFunction` ou `DynamicLibrary.lookupFunction` tem um argument
`isLeaf` cujo valor não é uma expressão constante.

O analisador também produz este diagnóstico quando uma invocação de
`Pointer.fromFunction` ou `NativeCallable.isolateLocal` tem um
argument `exceptionalReturn` cujo valor não é uma expressão constante.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o valor do
argument `isLeaf` é um parameter, e portanto não é uma constante:

```dart
import 'dart:ffi';

int Function(int) fromPointer(
    Pointer<NativeFunction<Int8 Function(Int8)>> p, bool isLeaf) {
  return p.asFunction(isLeaf: [!isLeaf!]);
}
```

## Common fixes

Se houver uma constante adequada que possa ser usada, então substitua o argument
por uma constante:

```dart
import 'dart:ffi';

const isLeaf = false;

int Function(int) fromPointer(Pointer<NativeFunction<Int8 Function(Int8)>> p) {
  return p.asFunction(isLeaf: isLeaf);
}
```

Se não houver uma constante adequada, então substitua o argument por um
literal booleano:

```dart
import 'dart:ffi';

int Function(int) fromPointer(Pointer<NativeFunction<Int8 Function(Int8)>> p) {
  return p.asFunction(isLeaf: true);
}
```

[ffi]: /interop/c-interop
