---
ia-translate: true
title: abi_specific_integer_mapping_unsupported
description: >-
  Detalhes sobre o diagnóstico abi_specific_integer_mapping_unsupported
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Invalid mapping to '{0}'; only mappings to 'Int8', 'Int16', 'Int32', 'Int64', 'Uint8', 'Uint16', 'UInt32', and 'Uint64' are supported._

## Description

O analisador produz este diagnóstico quando um valor no argumento de mapa de
uma anotação `AbiSpecificIntegerMapping` é algo diferente de um dos
seguintes tipos de inteiro:
- `Int8`
- `Int16`
- `Int32`
- `Int64`
- `Uint8`
- `Uint16`
- `UInt32`
- `Uint64`

## Example

O código a seguir produz este diagnóstico porque o valor da entrada do mapa
é `Array<Uint8>`, que não é um tipo de inteiro válido:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : [!Array<Uint8>(4)!]})
final class C extends AbiSpecificInteger {
  const C();
}
```

## Common fixes

Use um dos tipos válidos como valor no mapa:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
