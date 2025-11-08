---
title: import_of_non_library
description: >-
  Details about the import_of_non_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The imported library '{0}' can't have a part-of directive._

## Descrição

O analisador produz este diagnóstico quando a [part file][] is imported
into a library.

## Exemplo

Given a [part file][] named `part.dart` containing the following:

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque imported files can't
have a part-of directive:

```dart
library lib;

import [!'part.dart'!];
```

## Correções comuns

Import the library that contains the [part file][] rather than the
[part file][] itself.

[part file]: /resources/glossary#part-file
