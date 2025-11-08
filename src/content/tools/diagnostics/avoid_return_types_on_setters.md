---
title: avoid_return_types_on_setters
description: >-
  Details about the avoid_return_types_on_setters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_return_types_on_setters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary return type on a setter._

## Descrição

O analisador produz este diagnóstico quando a setter has an explicit return
type.

Setters never return a value, so declaring the return type of one is
redundant.

## Exemplo

O código a seguir produz este diagnóstico porque the setter `s` has an
explicit return type (`void`):

```dart
[!void!] set s(int p) {}
```

## Correções comuns

Remove the return type:

```dart
set s(int p) {}
```
