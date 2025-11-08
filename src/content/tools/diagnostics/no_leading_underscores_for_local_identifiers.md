---
ia-translate: true
title: no_leading_underscores_for_local_identifiers
description: >-
  Detalhes sobre o diagnóstico no_leading_underscores_for_local_identifiers
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_leading_underscores_for_local_identifiers"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The local variable '{0}' starts with an underscore._

## Description

O analisador produz este diagnóstico quando o nome de uma variável local
começa com um underscore.

Variáveis locais são inerentemente não visíveis fora da biblioteca declarante,
então um underscore inicial indicando privado não adiciona valor.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `_s`
começa com um underscore:

```dart
int f(String [!_s!]) => _s.length;
```

## Common fixes

Remova o underscore:

```dart
int f(String s) => s.length;
```
