---
ia-translate: true
title: generic_struct_subclass
description: >-
  Detalhes sobre o diagnóstico generic_struct_subclass
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode estender 'Struct' ou 'Union' porque '{0}' é generic._

## Description

O analisador produz este diagnóstico quando uma subclasse de `Struct`
ou `Union` possui um parâmetro de tipo.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `S` define
o parâmetro de tipo `T`:

```dart
import 'dart:ffi';

final class [!S!]<T> extends Struct {
  external Pointer notEmpty;
}
```

## Common fixes

Remova os parâmetros de tipo da classe:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

[ffi]: /interop/c-interop
