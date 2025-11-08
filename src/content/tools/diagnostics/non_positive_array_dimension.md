---
ia-translate: true
title: non_positive_array_dimension
description: "Detalhes sobre o diagnóstico non_positive_array_dimension produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_As dimensões do array devem ser números positivos._

## Description

O analisador produz este diagnóstico quando uma dimensão fornecida em uma anotação `Array`
é menor ou igual a zero (`0`).

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque uma dimensão de array de
`-8` foi fornecida:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array([!-8!])
  external Array<Uint8> a0;
}
```

## Common fixes

Altere a dimensão para ser um inteiro positivo:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

Se este é um array inline de comprimento variável, altere a anotação para
`Array.variable()`:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variable()
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
