---
title: abi_specific_integer_invalid
description: >-
  Details about the abi_specific_integer_invalid
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes extending 'AbiSpecificInteger' must have exactly one const constructor, no other members, and no type parameters._

## Descrição

O analisador produz este diagnóstico quando uma classe que estende
`AbiSpecificInteger` não atende a todos os seguintes requisitos:
- deve haver exatamente um construtor
- o construtor deve ser marcado como `const`
- não deve haver nenhum membro além do único construtor
- não deve haver nenhum parâmetro de tipo

## Exemplos

O código a seguir produz este diagnóstico porque a classe `C` doesn't
define a const construtor:

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

O código a seguir produz este diagnóstico porque a classe `C` defines
multiple construtores:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  const C.zero();
  const C.one();
}
```

O código a seguir produz este diagnóstico porque a classe `C` defines
a field:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  final int i;

  const C(this.i);
}
```

O código a seguir produz este diagnóstico porque a classe `C` has a
type parameter:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!]<T> extends AbiSpecificInteger { // type parameters
  const C();
}
```

## Correções comuns

Altere a classe para que atenda aos requisitos de não ter parâmetros de tipo
e um único membro que seja um construtor `const`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
