---
title: doc_import_cannot_have_configurations
description: >-
  Details about the doc_import_cannot_have_configurations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Doc imports can't have configurations._

## Descrição

O analisador produz este diagnóstico quando a documentation import has one
or more `if` clauses.

Documentation imports aren't configurable.

## Exemplo

O código a seguir produz este diagnóstico porque the documentation
import has an `if` clause:

```dart
/// @docImport 'package:meta/meta.dart' [!if (dart.library.io) 'dart:io'!];
library;
```

## Correções comuns

Remove the `if` clauses:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
