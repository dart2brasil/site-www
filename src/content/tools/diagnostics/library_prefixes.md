---
title: library_prefixes
description: >-
  Details about the library_prefixes
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_prefixes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The prefix '{0}' isn't a lower\_case\_with\_underscores identifier._

## Descrição

O analisador produz este diagnóstico quando an import prefix doesn't use
the lower_case_with_underscores naming convention.

## Exemplo

O código a seguir produz este diagnóstico porque the prefix
`ffiSupport` isn't a lower_case_with_underscores identifier:

```dart
import 'package:ffi/ffi.dart' as [!ffiSupport!];
```

## Correções comuns

Convert the prefix to use the lower_case_with_underscores naming
convention:

```dart
import 'package:ffi/ffi.dart' as ffi_support;
```
