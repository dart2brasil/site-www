---
ia-translate: true
title: extra_size_annotation_carray
description: >-
  Detalhes sobre o diagnóstico extra_size_annotation_carray
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'Array's devem ter exatamente uma anotação 'Array'._

## Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem mais de uma anotação descrevendo o tamanho do array
nativo.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o campo `a0` tem duas
anotações que especificam o tamanho do array nativo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(4)
  [!@Array(8)!]
  external Array<Uint8> a0;
}
```

## Correções comuns

Remova todas as anotações exceto uma:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
