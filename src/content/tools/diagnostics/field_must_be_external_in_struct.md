---
ia-translate: true
title: field_must_be_external_in_struct
description: "Detalhes sobre o diagnóstico field_must_be_external_in_struct produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos de subclasses de 'Struct' e 'Union' devem ser marcados como external._

## Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` não é marcado como `external`.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o campo `a` não é
marcado como `external`:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  int [!a!];
}
```

## Correções comuns

Adicione o modificador `external` obrigatório:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  external int a;
}
```

[ffi]: /interop/c-interop
