---
title: prefer_is_empty
description: >-
  Details about the prefer_is_empty
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_empty"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The comparison is always 'false' because the length is always greater than or equal to 0._

_The comparison is always 'true' because the length is always greater than or equal to 0._

_Use 'isEmpty' instead of 'length' to test whether the collection is empty._

_Use 'isNotEmpty' instead of 'length' to test whether the collection is empty._

## Descrição

O analisador produz este diagnóstico quando the result of invoking either
`Iterable.length` or `Map.length` is compared for equality with zero
(`0`).

## Exemplo

O código a seguir produz este diagnóstico porque the result of invoking
`length` is checked for equality with zero:

```dart
int f(Iterable<int> p) => [!p.length == 0!] ? 0 : p.first;
```

## Correções comuns

Replace the use of `length` with a use of either `isEmpty` or
`isNotEmpty`:

```dart
void f(Iterable<int> p) => p.isEmpty ? 0 : p.first;
```
