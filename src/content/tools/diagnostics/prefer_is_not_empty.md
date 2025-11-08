---
title: prefer_is_not_empty
description: >-
  Details about the prefer_is_not_empty
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_not_empty"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'isNotEmpty' rather than negating the result of 'isEmpty'._

## Descrição

O analisador produz este diagnóstico quando the result of invoking
`Iterable.isEmpty` or `Map.isEmpty` is negated.

## Exemplo

O código a seguir produz este diagnóstico porque the result of invoking
`Iterable.isEmpty` is negated:

```dart
void f(Iterable<int> p) => [!!p.isEmpty!] ? p.first : 0;
```

## Correções comuns

Rewrite the code to use `isNotEmpty`:

```dart
void f(Iterable<int> p) => p.isNotEmpty ? p.first : 0;
```
