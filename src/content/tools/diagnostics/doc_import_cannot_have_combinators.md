---
title: doc_import_cannot_have_combinators
description: >-
  Details about the doc_import_cannot_have_combinators
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Doc imports can't have show or hide combinators._

## Descrição

O analisador produz este diagnóstico quando a documentation import has one
or more `hide` or `show` combinators.

Using combinators isn't supported for documentation imports.

## Exemplo

O código a seguir produz este diagnóstico porque the documentation
import has a `show` combinator:

```dart
/// @docImport 'package:meta/meta.dart' [!show max!];
library;
```

## Correções comuns

Remove the `hide` and `show` combinators:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
