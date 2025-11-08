---
title: import_internal_library
description: >-
  Details about the import_internal_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The library '{0}' is internal and can't be imported._

## Descrição

O analisador produz este diagnóstico quando it finds an import whose `dart:`
URI references an internal library.

## Exemplo

O código a seguir produz este diagnóstico porque `_interceptors` is an
internal library:

```dart
import [!'dart:_interceptors'!];
```

## Correções comuns

Remove the import directive.
