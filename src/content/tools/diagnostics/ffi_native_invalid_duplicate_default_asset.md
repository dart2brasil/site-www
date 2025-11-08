---
title: ffi_native_invalid_duplicate_default_asset
description: >-
  Details about the ffi_native_invalid_duplicate_default_asset
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_There may be at most one @DefaultAsset annotation on a library._

## Descrição

O analisador produz este diagnóstico quando a library directive has more
than one `DefaultAsset` annotation associated with it.

## Exemplo

O código a seguir produz este diagnóstico porque the library directive
has two `DefaultAsset` annotations associated with it:

```dart
@DefaultAsset('a')
@[!DefaultAsset!]('b')
library;

import 'dart:ffi';
```

## Correções comuns

Remove all but one of the `DefaultAsset` annotations:

```dart
@DefaultAsset('a')
library;

import 'dart:ffi';
```
