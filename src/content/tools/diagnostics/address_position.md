---
title: address_position
description: >-
  Details about the address_position
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The '.address' expression can only be used as argument to a leaf native external call._

## Descrição

O analisador produz este diagnóstico quando the `.address` getter is used
in a context other than as an argument to a native external call that is
marked as a leaf call (`isLeaf: true`).

## Exemplo

O código a seguir produz este diagnóstico porque `.address` is used
incorrectly:

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

## Correções comuns

Ensure that the `.address` expression is used directly as an argument to a
native external call that is annotated with `@Native(...)` and has
`isLeaf: true` set in its annotation.

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
