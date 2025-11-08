---
title: abi_specific_integer_mapping_extra
description: >-
  Details about the abi_specific_integer_mapping_extra
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

## Descrição

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` tem mais de uma `AbiSpecificIntegerMapping`
annotation.

## Exemplo

O código a seguir produz este diagnóstico porque há duas
`AbiSpecificIntegerMapping` annotations na classe `C`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
@[!AbiSpecificIntegerMapping!]({Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```

## Correções comuns

Remova todas as anotações, exceto uma, mesclando os argumentos conforme
apropriado:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8(), Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```
