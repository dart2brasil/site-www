---
title: export_internal_library
description: >-
  Details about the export_internal_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The library '{0}' is internal and can't be exported._

## Descrição

O analisador produz este diagnóstico quando it finds an export whose `dart:`
URI references an internal library.

## Exemplo

O código a seguir produz este diagnóstico porque `_interceptors` is an
internal library:

```dart
export [!'dart:_interceptors'!];
```

## Correções comuns

Remove the export directive.
