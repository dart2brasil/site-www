---
ia-translate: true
title: non_sized_type_argument
description: >-
  Detalhes sobre o diagnóstico non_sized_type_argument
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' não é um argumento de tipo válido para '{1}'. O argumento de tipo deve ser um inteiro nativo, 'Float', 'Double', 'Pointer', ou subtipo de 'Struct', 'Union', ou 'AbiSpecificInteger'._

## Description

O analisador produz este diagnóstico quando o argumento de tipo para a classe
`Array` não é um dos tipos válidos: seja um inteiro nativo, `Float`,
`Double`, `Pointer`, ou subtipo de `Struct`, `Union`, ou
`AbiSpecificInteger`.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o argumento de tipo para
`Array` é `Void`, e `Void` não é um dos tipos válidos:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<[!Void!]> a0;
}
```

## Common fixes

Altere o argumento de tipo para um dos tipos válidos:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
