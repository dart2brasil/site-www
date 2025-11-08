---
title: missing_field_type_in_struct
description: "Detalhes sobre o diagnóstico missing_field_type_in_struct produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Campos em classes struct devem ter um tipo declarado explicitamente de 'int', 'double' ou 'Pointer'._

## Description

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` não tem uma anotação de tipo. Todo campo deve ter
um tipo explícito, e o tipo deve ser `int`, `double`, `Pointer`,
ou uma subclasse de `Struct` ou `Union`.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `str`
não tem uma anotação de tipo:

```dart
import 'dart:ffi';

final class C extends Struct {
  external var [!str!];

  @Int32()
  external int i;
}
```

## Common fixes

Especifique explicitamente o tipo do campo:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  external Pointer<Utf8> str;

  @Int32()
  external int i;
}
```

[ffi]: /interop/c-interop
