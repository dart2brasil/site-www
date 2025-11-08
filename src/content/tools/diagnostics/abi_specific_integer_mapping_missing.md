---
title: abi_specific_integer_mapping_missing
description: >-
  Details about the abi_specific_integer_mapping_missing
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

## Descrição

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` não tem uma `AbiSpecificIntegerMapping`
annotation.

## Exemplo

O código a seguir produz este diagnóstico porque não há
`AbiSpecificIntegerMapping` annotation na classe `C`:

```dart
import 'dart:ffi';

final class [!C!] extends AbiSpecificInteger {
  const C();
}
```

## Correções comuns

Adicione uma `AbiSpecificIntegerMapping` anotação à classe:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
