---
title: duplicate_export
description: >-
  Details about the duplicate_export
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Duplicate export._

## Descrição

O analisador produz este diagnóstico quando an export directive is found
that is the same as an export before it in the file. The second export
doesn't add value and should be removed.

## Exemplo

O código a seguir produz este diagnóstico porque the same library is
being exported twice:

```dart
export 'package:meta/meta.dart';
export [!'package:meta/meta.dart'!];
```

## Correções comuns

Remove the unnecessary export:

```dart
export 'package:meta/meta.dart';
```
