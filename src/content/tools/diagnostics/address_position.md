---
ia-translate: true
title: address_position
description: >-
  Detalhes sobre o diagnóstico address_position
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The '.address' expression can only be used as argument to a leaf native external call._

## Description

O analisador produz este diagnóstico quando o getter `.address` é usado
em um contexto que não seja como argumento para uma chamada externa nativa que é
marcada como uma chamada leaf (`isLeaf: true`).

## Example

O código a seguir produz este diagnóstico porque `.address` é usado
incorretamente:

```dart
import 'dart:ffi';
import 'dart:typed_data';

@Native<Void Function(Pointer<Uint8>)>()
external void nonLeafCall(Pointer<Uint8> ptr);

void main() {
  final data = Uint8List(10);

  // Incorrect: Using '.address' as an argument to a non-leaf call.
  nonLeafCall(data.[!address!]);
}
```

## Common fixes

Certifique-se de que a expressão `.address` seja usada diretamente como argumento para uma
chamada externa nativa que está anotada com `@Native(...)` e tem
`isLeaf: true` definido em sua anotação.

```dart
import 'dart:ffi';
import 'dart:typed_data';

@Native<Void Function(Pointer<Uint8>)>(isLeaf: true)
external void leafCall(Pointer<Uint8> ptr);

void main() {
  final data = Uint8List(10);

  // Correct: Using .address directly as an argument to a leaf call.
  leafCall(data.address);
}
```
