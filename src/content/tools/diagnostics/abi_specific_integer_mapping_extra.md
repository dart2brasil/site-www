---
ia-translate: true
title: abi_specific_integer_mapping_extra
description: "Detalhes sobre o diagnóstico abi_specific_integer_mapping_extra produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

## Description

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` tem mais de uma anotação `AbiSpecificIntegerMapping`.

## Example

O código a seguir produz este diagnóstico porque há duas
anotações `AbiSpecificIntegerMapping` na classe `C`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
@[!AbiSpecificIntegerMapping!]({Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```

## Common fixes

Remova todas as anotações exceto uma, mesclando os argumentos conforme
apropriado:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8(), Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```
