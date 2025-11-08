---
title: library_prefixes
description: >-
  Detalhes sobre o diagnóstico library_prefixes
  produzido pelo analisador Dart.
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

_O prefixo '{0}' não é um identificador lower\_case\_with\_underscores._

## Descrição

O analisador produz este diagnóstico quando um prefixo de import não usa
a convenção de nomenclatura lower_case_with_underscores.

## Exemplo

O código a seguir produz este diagnóstico porque o prefixo
`ffiSupport` não é um identificador lower_case_with_underscores:

```dart
import 'package:ffi/ffi.dart' as [!ffiSupport!];
```

## Correções comuns

Converta o prefixo para usar a convenção de nomenclatura
lower_case_with_underscores:

```dart
import 'package:ffi/ffi.dart' as ffi_support;
```
