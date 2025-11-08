---
ia-translate: true
title: variable_length_array_not_last
description: >-
  Detalhes sobre o diagnóstico variable_length_array_not_last
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'Array's de comprimento variável devem ocorrer apenas como o último campo de Structs._

## Descrição

O analisador produz este diagnóstico quando um `Array` inline de comprimento variável
não é o último membro de um `Struct`.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o campo `a0` tem um
tipo com três arrays aninhados, mas apenas duas dimensões são fornecidas na
anotação `Array`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Array.variable()!]
  external Array<Uint8> a0;

  @Uint8()
  external int a1;
}
```

## Correções comuns

Mova o `Array` inline de comprimento variável para ser o último campo no struct.

```dart
import 'dart:ffi';

final class C extends Struct {
  @Uint8()
  external int a1;

  @Array.variable()
  external Array<Uint8> a0;
}
```

Se o array inline tem tamanho fixo, anote-o com o tamanho:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(10)
  external Array<Uint8> a0;

  @Uint8()
  external int a1;
}
```

[ffi]: /interop/c-interop
