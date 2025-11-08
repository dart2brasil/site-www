---
ia-translate: true
title: generic_struct_subclass
description: >-
  Detalhes sobre o diagnóstico generic_struct_subclass
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode estender 'Struct' ou 'Union' porque '{0}' é generic._

## Description

O analisador produz este diagnóstico quando uma subclasse de `Struct`
ou `Union` tem um type parameter.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `S` define
o type parameter `T`:

```dart
import 'dart:ffi';

final class [!S!]<T> extends Struct {
  external Pointer notEmpty;
}
```

## Common fixes

Remova os type parameters da classe:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

[ffi]: /interop/c-interop
