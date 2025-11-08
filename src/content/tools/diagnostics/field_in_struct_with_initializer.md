---
ia-translate: true
title: field_in_struct_with_initializer
description: >-
  Detalhes sobre o diagnóstico field_in_struct_with_initializer
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos em subclasses de 'Struct' e 'Union' não podem ter inicializadores._

## Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` possui um inicializador.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o campo `p` possui um
inicializador:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer [!p!] = nullptr;
}
```

## Correções comuns

Remova o inicializador:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer p;
}
```

[ffi]: /interop/c-interop
