---
title: part_of_unnamed_library
description: >-
  Details about the part_of_unnamed_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The library is unnamed. A URI is expected, not a library name '{0}', in the part-of directive._

## Descrição

O analisador produz este diagnóstico quando a library that doesn't have a
`library` directive (and hence has no name) contains a `part` directive
and the `part of` directive in the [part file][] uses a name to specify
the library that it's a part of.

## Exemplo

Given a [part file][] named `part_file.dart` containing the following
code:

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque the library including
the [part file][] doesn't have a name even though the [part file][] uses a
name to specify which library it's a part of:

```dart
part [!'part_file.dart'!];
```

## Correções comuns

Change the `part of` directive in the [part file][] to specify its library
by URI:

```dart
part of 'test.dart';
```

[part file]: /resources/glossary#part-file
