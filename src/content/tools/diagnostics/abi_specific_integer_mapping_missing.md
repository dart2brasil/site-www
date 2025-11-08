---
ia-translate: true
title: abi_specific_integer_mapping_missing
description: "Detalhes sobre o diagnóstico abi_specific_integer_mapping_missing produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

## Description

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` não possui uma anotação `AbiSpecificIntegerMapping`.

## Example

O código a seguir produz este diagnóstico porque não há
anotação `AbiSpecificIntegerMapping` na classe `C`:

```dart
import 'dart:ffi';

final class [!C!] extends AbiSpecificInteger {
  const C();
}
```

## Common fixes

Adicione uma anotação `AbiSpecificIntegerMapping` à classe:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
