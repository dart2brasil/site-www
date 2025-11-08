---
ia-translate: true
title: native_field_invalid_type
description: >-
  Detalhes sobre o diagnóstico native_field_invalid_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' is an unsupported type for native fields. Native fields only support pointers, arrays or numeric and compound types._

## Description

O analisador produz este diagnóstico quando um campo anotado com `@Native`
possui um tipo não suportado para campos native.

Campos native suportam pointers, arrays, tipos numéricos e subtipos de
`Compound` (ou seja, structs ou unions). Outros subtipos de `NativeType`,
como `Handle` ou `NativeFunction` não são permitidos como campos native.

Funções native devem ser usadas com funções external em vez de
campos external.

Handles não são suportados porque não há maneira de carregar e armazenar
transparentemente objetos Dart em pointers.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `free` usa
um tipo native não suportado, `NativeFunction`:

```dart
import 'dart:ffi';

@Native<NativeFunction<Void Function()>>()
external void Function() [!free!];
```

## Common fixes

Se você pretendia vincular a uma função native existente com um
campo `NativeFunction`, use métodos `@Native` em vez disso:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
external void free(Pointer<Void> ptr);
```

Para vincular a um campo que armazena um ponteiro de função em C, use um tipo pointer
para o campo Dart:

```dart
import 'dart:ffi';

@Native()
external Pointer<NativeFunction<Void Function(Pointer<Void>)>> free;
```

[ffi]: /interop/c-interop
