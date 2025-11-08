---
title: use_of_native_extension
description: >-
  Details about the use_of_native_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Dart native extensions are deprecated and aren't available in Dart 2.15._

## Descrição

O analisador produz este diagnóstico quando a library is imported using the
`dart-ext` scheme.

## Exemplo

O código a seguir produz este diagnóstico porque the native library `x`
is being imported using a scheme of `dart-ext`:

```dart
import [!'dart-ext:x'!];
```

## Correções comuns

Rewrite the code to use `dart:ffi` as a way of invoking the contents of the
native library.
