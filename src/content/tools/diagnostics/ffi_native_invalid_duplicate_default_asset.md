---
ia-translate: true
title: ffi_native_invalid_duplicate_default_asset
description: "Detalhes sobre o diagnóstico ffi_native_invalid_duplicate_default_asset produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Pode haver no máximo uma anotação @DefaultAsset em uma biblioteca._

## Description

O analisador produz este diagnóstico quando uma diretiva de biblioteca tem
mais de uma anotação `DefaultAsset` associada a ela.

## Example

O código a seguir produz este diagnóstico porque a diretiva de biblioteca
tem duas anotações `DefaultAsset` associadas a ela:

```dart
@DefaultAsset('a')
@[!DefaultAsset!]('b')
library;

import 'dart:ffi';
```

## Common fixes

Remova todas as anotações `DefaultAsset`, exceto uma:

```dart
@DefaultAsset('a')
library;

import 'dart:ffi';
```
