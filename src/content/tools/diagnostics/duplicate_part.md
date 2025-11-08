---
title: duplicate_part
description: >-
  Details about the duplicate_part
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The library already contains a part with the URI '{0}'._

## Descrição

O analisador produz este diagnóstico quando a single file is referenced in
multiple part directives.

## Exemplo

Given a file `part.dart` containing

```dart
part of 'test.dart';
```

O código a seguir produz este diagnóstico porque the file `part.dart` is
included multiple times:

```dart
part 'part.dart';
part [!'part.dart'!];
```

## Correções comuns

Remove all except the first of the duplicated part directives:

```dart
part 'part.dart';
```
