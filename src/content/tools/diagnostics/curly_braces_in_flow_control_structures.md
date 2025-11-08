---
title: curly_braces_in_flow_control_structures
description: >-
  Details about the curly_braces_in_flow_control_structures
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_Statements in {0} should be enclosed in a block._

## Descrição

O analisador produz este diagnóstico quando a control structure (`if`,
`for`, `while`, or `do` statement) has a statement other than a block.

## Exemplo

O código a seguir produz este diagnóstico porque the `then` statement
is not enclosed in a block:

```dart
int f(bool b) {
  if (b)
    [!return 1;!]
  return 0;
}
```

## Correções comuns

Add braces around the statement that should be a block:

```dart
int f(bool b) {
  if (b) {
    return 1;
  }
  return 0;
}
```
