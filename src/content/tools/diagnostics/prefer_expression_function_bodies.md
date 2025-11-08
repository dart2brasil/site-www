---
title: prefer_expression_function_bodies
description: >-
  Details about the prefer_expression_function_bodies
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_expression_function_bodies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of a block function body._

## Descrição

O analisador produz este diagnóstico quando the body of a function consists
of a single return statement with an expression.

## Exemplo

O código a seguir produz este diagnóstico porque the body of `f` has a
single return statement:

```dart
int f() [!{!]
  [!return 0;!]
[!}!]
```

## Correções comuns

If the body is complete, then replace the body with an expression body:

```dart
int f() => 0;
```

If the body isn't complete, then add the missing statements.
