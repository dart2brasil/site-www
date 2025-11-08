---
ia-translate: true
title: packed_annotation
description: >-
  Detalhes sobre o diagnóstico packed_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Structs devem ter no máximo uma anotação 'Packed'._

## Description

O analisador produz este diagnóstico quando uma subclasse de `Struct` tem mais
de uma anotação `Packed`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `C`, que
é uma subclasse de `Struct`, tem duas anotações `Packed`:

```dart
import 'dart:ffi';

@Packed(1)
[!@Packed(1)!]
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

## Common fixes

Remova todas, exceto uma das anotações:

```dart
import 'dart:ffi';

@Packed(1)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

[ffi]: /interop/c-interop
