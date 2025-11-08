---
title: doc_import_cannot_have_prefix
description: >-
  Details about the doc_import_cannot_have_prefix
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Doc imports can't have prefixes._

## Descrição

O analisador produz este diagnóstico quando a documentation import has a
prefix.

Using prefixes isn't supported for documentation imports.

## Exemplo

O código a seguir produz este diagnóstico porque the documentation
import declares a prefix:

```dart
/// @docImport 'package:meta/meta.dart' as [!a!];
library;
```

## Correções comuns

Remove the prefix:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
