---
ia-translate: true
title: no_leading_underscores_for_library_prefixes
description: "Detalhes sobre o diagnóstico no_leading_underscores_for_library_prefixes produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_leading_underscores_for_library_prefixes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The library prefix '{0}' starts with an underscore._

## Description

O analisador produz este diagnóstico quando o nome de um prefixo declarado
em um import começa com um underscore.

Prefixos de biblioteca são inerentemente não visíveis fora da biblioteca declarante,
então um underscore inicial indicando privado não adiciona valor.

## Example

O código a seguir produz este diagnóstico porque o prefixo `_core`
começa com um underscore:

```dart
import 'dart:core' as [!_core!];
```

## Common fixes

Remova o underscore:

```dart
import 'dart:core' as core;
```
