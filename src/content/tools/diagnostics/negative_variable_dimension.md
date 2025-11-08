---
ia-translate: true
title: negative_variable_dimension
description: >-
  Detalhes sobre o diagnóstico negative_variable_dimension
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A dimensão variável de um array de comprimento variável deve ser não-negativa._

## Description

O analisador produz este diagnóstico em dois casos.

O primeiro é quando a dimensão variável fornecida em uma
anotação `Array.variableWithVariableDimension` é negativa. A dimensão
variável é o primeiro argumento na anotação.

O segundo é quando a dimensão variável fornecida em uma
anotação `Array.variableMulti` é negativa. A dimensão variável é
especificada no argumento `variableDimension` da anotação.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Examples

O código a seguir produz este diagnóstico porque uma dimensão variável
de `-1` foi fornecida na anotação `Array.variableWithVariableDimension`:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variableWithVariableDimension([!-1!])
  external Array<Uint8> a0;
}
```

O código a seguir produz este diagnóstico porque uma dimensão variável
de `-1` foi fornecida na anotação `Array.variableMulti`:

```dart
import 'dart:ffi';

final class MyStruct2 extends Struct {
  @Array.variableMulti(variableDimension: [!-1!], [1, 2])
  external Array<Array<Array<Uint8>>> a0;
}
```

## Common fixes

Altere a dimensão variável para zero (`0`) ou um número positivo:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variableWithVariableDimension(1)
  external Array<Uint8> a0;
}
```

Altere a dimensão variável para zero (`0`) ou um número positivo:

```dart
import 'dart:ffi';

final class MyStruct2 extends Struct {
  @Array.variableMulti(variableDimension: 1, [1, 2])
  external Array<Array<Array<Uint8>>> a0;
}
```

[ffi]: /interop/c-interop
