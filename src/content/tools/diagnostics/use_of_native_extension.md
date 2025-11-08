---
ia-translate: true
title: use_of_native_extension
description: >-
  Detalhes sobre o diagnóstico use_of_native_extension
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extensões nativas do Dart estão descontinuadas e não estão disponíveis no Dart 2.15._

## Descrição

O analisador produz este diagnóstico quando uma biblioteca é importada usando o
esquema `dart-ext`.

## Exemplo

O código a seguir produz este diagnóstico porque a biblioteca nativa `x`
está sendo importada usando um esquema `dart-ext`:

```dart
import [!'dart-ext:x'!];
```

## Correções comuns

Reescreva o código para usar `dart:ffi` como forma de invocar o conteúdo da
biblioteca nativa.
