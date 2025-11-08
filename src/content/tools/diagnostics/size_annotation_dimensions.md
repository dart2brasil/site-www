---
ia-translate: true
title: size_annotation_dimensions
description: >-
  Detalhes sobre o diagnóstico size_annotation_dimensions
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'Array's devem ter uma anotação 'Array' que corresponda às dimensões._

## Description

O analisador produz este diagnóstico quando o número de dimensões
especificado em uma anotação `Array` não corresponde ao número de
arrays aninhados especificados pelo tipo de um campo.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `a0` tem um
tipo com três arrays aninhados, mas apenas duas dimensões são fornecidas na
anotação `Array`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Array(8, 8)!]
  external Array<Array<Array<Uint8>>> a0;
}
```

## Common fixes

Se o tipo do campo está correto, então corrija a anotação para ter o
número necessário de dimensões:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8, 8, 4)
  external Array<Array<Array<Uint8>>> a0;
}
```

Se o tipo do campo está errado, então corrija o tipo do campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8, 8)
  external Array<Array<Uint8>> a0;
}
```

[ffi]: /interop/c-interop
