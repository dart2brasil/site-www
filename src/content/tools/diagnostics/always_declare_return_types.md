---
ia-translate: true
title: always_declare_return_types
description: >-
  Detalhes sobre o diagnóstico always_declare_return_types
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_declare_return_types"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The function '{0}' should have a return type but doesn't._

_The method '{0}' should have a return type but doesn't._

## Description

O analisador produz este diagnóstico quando um método ou função não
possui um tipo de retorno explícito.

## Example

O código a seguir produz este diagnóstico porque a função `f`
não tem um tipo de retorno:

```dart
[!f!]() {}
```

## Common fixes

Adicione um tipo de retorno explícito:

```dart
void f() {}
```
