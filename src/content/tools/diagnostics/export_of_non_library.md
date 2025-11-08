---
title: export_of_non_library
description: >-
  Details about the export_of_non_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The exported library '{0}' can't have a part-of directive._

## Descrição

O analisador produz este diagnóstico quando an export directive references a
part rather than a library.

## Exemplo

Given a file `part.dart` containing

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque the file `part.dart` is
a part, and only libraries can be exported:

```dart
library lib;

export [!'part.dart'!];
```

## Correções comuns

Either remove the export directive, or change the URI to be the URI of the
library containing the part.
