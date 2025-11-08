---
ia-translate: true
title: abi_specific_integer_invalid
description: "Detalhes sobre o diagnóstico abi_specific_integer_invalid produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes extending 'AbiSpecificInteger' must have exactly one const constructor, no other members, and no type parameters._

## Description

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` não atende a todos os seguintes requisitos:
- deve haver exatamente um construtor
- o construtor deve ser marcado como `const`
- não deve haver nenhum membro além do único construtor
- não deve haver nenhum type parameter

## Examples

O código a seguir produz este diagnóstico porque a classe `C` não
define um construtor const:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
}
```

O código a seguir produz este diagnóstico porque o construtor não é
um construtor `const`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  C();
}
```

O código a seguir produz este diagnóstico porque a classe `C` define
múltiplos construtores:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  const C.zero();
  const C.one();
}
```

O código a seguir produz este diagnóstico porque a classe `C` define
um campo:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  final int i;

  const C(this.i);
}
```

O código a seguir produz este diagnóstico porque a classe `C` tem um
type parameter:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!]<T> extends AbiSpecificInteger { // type parameters
  const C();
}
```

## Common fixes

Altere a classe para que ela atenda aos requisitos de não ter type
parameters e ter um único membro que seja um construtor `const`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
