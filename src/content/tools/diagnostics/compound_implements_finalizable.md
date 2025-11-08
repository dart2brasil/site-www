---
ia-translate: true
title: compound_implements_finalizable
description: >-
  Detalhes sobre o diagnóstico compound_implements_finalizable
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode implementar Finalizable._

## Description

O analisador produz este diagnóstico quando uma subclasse de `Struct`
ou `Union` implementa `Finalizable`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `S`
implementa `Finalizable`:

```dart
import 'dart:ffi';

final class [!S!] extends Struct implements Finalizable {
  external Pointer notEmpty;
}
```

## Common fixes

Tente remover a cláusula implements da classe:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

[ffi]: /interop/c-interop
