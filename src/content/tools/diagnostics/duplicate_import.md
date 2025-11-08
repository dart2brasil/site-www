---
title: duplicate_import
description: >-
  Details about the duplicate_import
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Duplicate import._

## Descrição

O analisador produz este diagnóstico quando an import directive is found
that is the same as an import before it in the file. The second import
doesn't add value and should be removed.

## Exemplo

The following code produces this diagnostic:

```dart
import 'package:meta/meta.dart';
import [!'package:meta/meta.dart'!];

@sealed class C {}
```

## Correções comuns

Remove the unnecessary import:

```dart
import 'package:meta/meta.dart';

@sealed class C {}
```
