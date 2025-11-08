---
title: use_truncating_division
description: >-
  Details about the use_truncating_division
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_truncating_division"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use truncating division._

## Descrição

O analisador produz este diagnóstico quando the result of dividing two
numbers is converted to an integer using `toInt`.

Dart has a built-in integer division operator that is both more efficient
and more concise.

## Exemplo

O código a seguir produz este diagnóstico porque the result of dividing
`x` and `y` is converted to an integer using `toInt`:

```dart
int divide(int x, int y) => [!(x / y).toInt()!];
```

## Correções comuns

Use the integer division operator (`~/`):

```dart
int divide(int x, int y) => x ~/ y;
```
