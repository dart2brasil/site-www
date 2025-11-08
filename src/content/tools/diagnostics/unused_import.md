---
title: unused_import
description: >-
  Details about the unused_import
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Unused import: '{0}'._

## Descrição

O analisador produz este diagnóstico quando an import isn't needed because
none of the names that are imported are referenced within the importing
library.

## Exemplo

O código a seguir produz este diagnóstico porque nothing defined in
`dart:async` is referenced in the library:

```dart
import [!'dart:async'!];

void main() {}
```

## Correções comuns

If the import isn't needed, then remove it.

If some of the imported names are intended to be used, then add the missing
code.
