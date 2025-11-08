---
ia-translate: true
title: native_function_missing_type
description: >-
  Detalhes sobre o diagnóstico native_function_missing_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The native type of this function couldn't be inferred so it must be specified in the annotation._

## Description

O analisador produz este diagnóstico quando uma função anotada com `@Native`
requer uma dica de tipo na annotation para inferir o tipo da função native.

Tipos Dart como `int` e `double` possuem múltiplas representações native
possíveis. Como o tipo native precisa ser conhecido em tempo de compilação
para gerar bindings e instruções de chamada corretas para a função, um
tipo explícito deve ser fornecido.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a função `f()` possui
o tipo de retorno `int`, mas não possui um parâmetro de tipo explícito na
annotation `Native`:

```dart
import 'dart:ffi';

@Native()
external int [!f!]();
```

## Common fixes

Adicione o tipo correspondente à annotation. Por exemplo, se `f()` foi
declarada para retornar um `int32_t` em C, a função Dart deve ser declarada
como:

```dart
import 'dart:ffi';

@Native<Int32 Function()>()
external int f();
```

[ffi]: /interop/c-interop
