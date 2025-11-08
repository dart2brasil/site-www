---
ia-translate: true
title: packed_annotation_alignment
description: >-
  Detalhes sobre o diagnóstico packed_annotation_alignment
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas packing para 1, 2, 4, 8, e 16 bytes é suportado._

## Description

O analisador produz este diagnóstico quando o argumento para a anotação `Packed`
não é um dos valores permitidos: 1, 2, 4, 8, ou 16.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o argumento para a
anotação `Packed` (`3`) não é um dos valores permitidos:

```dart
import 'dart:ffi';

@Packed([!3!])
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

## Common fixes

Altere o alinhamento para ser um dos valores permitidos:

```dart
import 'dart:ffi';

@Packed(4)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

[ffi]: /interop/c-interop
