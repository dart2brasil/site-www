---
ia-translate: true
title: ffi_native_must_be_external
description: >-
  Detalhes sobre o diagnóstico ffi_native_must_be_external
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Funções nativas devem ser declaradas como external._

## Description

O analisador produz este diagnóstico quando uma função anotada como
`@Native` não está marcada como `external`.

## Example

O código a seguir produz este diagnóstico porque a função `free` é
anotada como sendo `@Native`, mas a função não está marcada como `external`:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
void [!free!](Pointer<Void> ptr) {}
```

## Common fixes

Se a função é uma função nativa, adicione o modificador `external`
antes do tipo de retorno:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
external void free(Pointer<Void> ptr);
```
