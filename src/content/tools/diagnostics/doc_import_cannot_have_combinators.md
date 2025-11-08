---
ia-translate: true
title: doc_import_cannot_have_combinators
description: >-
  Detalhes sobre o diagnóstico doc_import_cannot_have_combinators
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Doc imports não podem ter combinators show ou hide._

## Description

O analisador produz este diagnóstico quando um documentation import tem um
ou mais combinators `hide` ou `show`.

Usar combinators não é suportado para documentation imports.

## Example

O código a seguir produz este diagnóstico porque o documentation
import tem um combinator `show`:

```dart
/// @docImport 'package:meta/meta.dart' [!show max!];
library;
```

## Common fixes

Remova os combinators `hide` e `show`:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
