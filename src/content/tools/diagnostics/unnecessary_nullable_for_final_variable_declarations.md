---
ia-translate: true
title: unnecessary_nullable_for_final_variable_declarations
description: "Detalhes sobre o diagnóstico unnecessary_nullable_for_final_variable_declarations produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_nullable_for_final_variable_declarations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O tipo poderia ser não-nullable._

## Description

O analisador produz este diagnóstico quando um campo ou variável final tem um
tipo nullable mas é inicializado com um valor não-nullable.

## Example

O código a seguir produz este diagnóstico porque a variável final `i`
tem um tipo nullable (`int?`), mas nunca pode ser `null`:

```dart
final int? [!i!] = 1;
```

## Common fixes

Torne o tipo não-nullable:

```dart
final int i = 1;
```
