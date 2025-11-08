---
ia-translate: true
title: always_put_required_named_parameters_first
description: >-
  Detalhes sobre o diagnóstico always_put_required_named_parameters_first
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_put_required_named_parameters_first"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Required named parameters should be before optional named parameters._

## Description

O analisador produz este diagnóstico quando parâmetros nomeados required ocorrem
após parâmetros nomeados opcionais.

## Example

O código a seguir produz este diagnóstico porque o parâmetro required
`x` está após o parâmetro opcional `y`:

```dart
void f({int? y, required int [!x!]}) {}
```

## Common fixes

Reordene os parâmetros para que todos os parâmetros nomeados required estejam antes
de quaisquer parâmetros nomeados opcionais:

```dart
void f({required int x, int? y}) {}
```
