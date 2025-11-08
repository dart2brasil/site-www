---
ia-translate: true
title: creation_of_struct_or_union
description: >-
  Detalhes sobre o diagnóstico creation_of_struct_or_union
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Subclasses de 'Struct' e 'Union' são suportadas por memória nativa, e não podem ser instanciadas por um construtor generativo._

## Description

O analisador produz este diagnóstico quando uma subclasse de `Struct`
ou `Union` é instanciada usando um construtor generativo.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `C` está sendo
instanciada usando um construtor generativo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int a;
}

void f() {
  [!C!]();
}
```

## Common fixes

Se você precisa alocar a estrutura descrita pela classe, então use o
pacote `ffi` para fazer isso:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  @Int32()
  external int a;
}

void f() {
  final pointer = calloc.allocate<C>(4);
  final c = pointer.ref;
  print(c);
  calloc.free(pointer);
}
```

[ffi]: /interop/c-interop
