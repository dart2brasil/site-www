---
ia-translate: true
title: field_initializer_in_struct
description: >-
  Detalhes sobre o diagnóstico field_initializer_in_struct
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores em subclasses de 'Struct' e 'Union' não podem ter inicializadores de campo._

## Descrição

O analisador produz este diagnóstico quando um construtor em uma subclasse de
`Struct` ou `Union` possui um ou mais inicializadores de campo.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` possui um
construtor com um inicializador para o campo `f`:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  int f;

  C() : [!f = 0!];
}
```

## Correções comuns

Remova o inicializador de campo:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  int f;

  C();
}
```

[ffi]: /interop/c-interop
