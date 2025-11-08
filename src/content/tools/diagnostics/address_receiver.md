---
ia-translate: true
title: address_receiver
description: "Detalhes sobre o diagnóstico address_receiver produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The receiver of '.address' must be a concrete 'TypedData', a concrete 'TypedData' '[]', an 'Array', an 'Array' '[]', a Struct field, or a Union field._

## Description

O analisador produz este diagnóstico quando o getter `.address` é usado
em um receptor cujo tipo estático não é um dos tipos FFI permitidos. O
getter `.address` é usado para obter um `Pointer` para a memória subjacente
de uma estrutura de dados FFI.

O receptor de `.address` deve ser um dos seguintes:
- Uma instância concreta de `TypedData` (por exemplo, `Uint8List`).
- Um elemento de uma instância concreta de `TypedData` acessado via `[]`.
- Uma instância de `Array<T>` (de `dart:ffi`).
- Um elemento de uma instância de `Array<T>` acessado via `[]`.
- Um campo de uma subclasse `Struct` ou `Union`, se o tipo desse campo for `Array<T>`, um `Struct` aninhado ou um `Union` aninhado.
- Uma instância de `Struct` ou `Union`.

## Example

O código a seguir produz este diagnóstico para vários receptores incorretos:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Uint8()
  external int x;

  @Uint8()
  external int y;
}

@Native<Void Function(Pointer)>(isLeaf: true)
external void nativeLeafCall(Pointer ptr);

void main() {
  final struct = Struct.create<MyStruct>();
  final y = struct.y;
  // Incorrect: The receiver is not a struct field, but some integer.
  nativeLeafCall(y.[!address!]);
}
```

## Common fixes

Certifique-se de que o receptor do getter `.address` seja um dos tipos
permitidos. O getter `.address` é para obter um `Pointer` para a memória
de instâncias `TypedData`, `Array`, `Struct` ou `Union`, ou certos
campos/elementos delas.

```dart
import 'dart:ffi';

@Native<Void Function(Pointer)>(isLeaf: true)
external void nativeLeafCall(Pointer ptr);

final class MyStruct extends Struct {
  @Uint8()
  external int x;

  @Uint8()
  external int y;
}

void main() {
  final struct = Struct.create<MyStruct>();
  // Correct: The receiver is a struct field.
  nativeLeafCall(struct.y.address);
}
```
