---
title: missing_whitespace_between_adjacent_strings
description: >-
  Details about the missing_whitespace_between_adjacent_strings
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/missing_whitespace_between_adjacent_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing whitespace between adjacent strings._

## Descrição

The analyzer produces this diagnostic for a pair of adjacent string
literals unless either the left-hand string ends in whitespace or the
right-hand string begins with whitespace.

## Exemplo

O código a seguir produz este diagnóstico porque neither the left nor
the right string literal includes a space to separate the words that will
be joined:

```dart
var s =
  [!'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed'!]
  'do eiusmod tempor incididunt ut labore et dolore magna';
```

## Correções comuns

Add whitespace at the end of the left-hand literal or at the beginning of
the right-hand literal:

```dart
var s =
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed '
  'do eiusmod tempor incididunt ut labore et dolore magna';
```
