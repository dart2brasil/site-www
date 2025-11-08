---
ia-translate: true
title: native_field_missing_type
description: >-
  Detalhes sobre o diagnóstico native_field_missing_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The native type of this field could not be inferred and must be specified in the annotation._

## Description

O analisador produz este diagnóstico quando um campo anotado com `@Native`
requer uma dica de tipo na annotation para inferir o tipo native.

Tipos Dart como `int` e `double` possuem múltiplas representações native
possíveis. Como o tipo native precisa ser conhecido em tempo de compilação
para gerar as operações corretas de carga e armazenamento ao acessar o campo,
um tipo explícito deve ser fornecido.

## Example

O código a seguir produz este diagnóstico porque o campo `f` possui
o tipo `int` (para o qual existem múltiplas representações native), mas nenhum
parâmetro de tipo explícito na annotation `Native`:

```dart
import 'dart:ffi';

@Native()
external int [!f!];
```

## Common fixes

Para corrigir este diagnóstico, descubra a representação native correta a partir
da declaração native do campo. Então, adicione o tipo correspondente à
annotation. Por exemplo, se `f` foi declarado como `uint8_t` em C,
o campo Dart deve ser declarado como:

```dart
import 'dart:ffi';

@Native<Uint8>()
external int f;
```

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

[ffi]: /interop/c-interop
