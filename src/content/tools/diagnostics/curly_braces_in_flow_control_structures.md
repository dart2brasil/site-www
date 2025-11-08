---
ia-translate: true
title: curly_braces_in_flow_control_structures
description: >-
  Detalhes sobre o diagnóstico curly_braces_in_flow_control_structures
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/curly_braces_in_flow_control_structures"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Statements em {0} devem ser incluídos em um bloco._

## Description

O analisador produz este diagnóstico quando uma estrutura de controle (`if`,
`for`, `while`, ou statement `do`) tem um statement diferente de um bloco.

## Example

O código a seguir produz este diagnóstico porque o statement `then`
não está incluído em um bloco:

```dart
int f(bool b) {
  if (b)
    [!return 1;!]
  return 0;
}
```

## Common fixes

Adicione chaves ao redor do statement que deve ser um bloco:

```dart
int f(bool b) {
  if (b) {
    return 1;
  }
  return 0;
}
```
