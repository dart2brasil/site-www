---
ia-translate: true
title: annotation_on_pointer_field
description: >-
  Detalhes sobre o diagnóstico annotation_on_pointer_field
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos em uma classe struct cujo tipo é 'Pointer' não devem ter nenhuma anotação._

## Descrição

O analisador produz este diagnóstico quando um campo que está declarado em uma
subclasse de `Struct` e tem o tipo `Pointer` também tem uma anotação
associada a ele.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o campo `p`, que
tem o tipo `Pointer` e está declarado em uma subclasse de `Struct`, tem a
anotação `@Double()`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external Pointer<Int8> p;
}
```

## Correções comuns

Remova as anotações do campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  external Pointer<Int8> p;
}
```

[ffi]: /interop/c-interop
