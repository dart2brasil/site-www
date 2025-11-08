---
ia-translate: true
title: invalid_field_type_in_struct
description: >-
  Detalhes sobre o diagnóstico invalid_field_type_in_struct
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos em classes struct não podem ter o tipo '{0}'. Eles só podem ser declarados como 'int', 'double', 'Array', 'Pointer', ou subtipo de 'Struct' ou 'Union'._

## Description

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem um tipo diferente de `int`, `double`, `Array`, `Pointer`, ou
subtipo de `Struct` ou `Union`.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `str` tem o tipo
`String`, que não é um dos tipos permitidos para campos em uma subclasse de
`Struct`:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!String!] s;

  @Int32()
  external int i;
}
```

## Common fixes

Use um dos tipos permitidos para o campo:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  external Pointer<Utf8> s;

  @Int32()
  external int i;
}
```

[ffi]: /interop/c-interop
