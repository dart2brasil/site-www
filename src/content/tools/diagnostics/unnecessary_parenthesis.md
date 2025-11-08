---
ia-translate: true
title: unnecessary_parenthesis
description: "Detalhes sobre o diagnóstico unnecessary_parenthesis produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_parenthesis"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de parênteses._

## Description

O analisador produz este diagnóstico quando parênteses são usados onde eles
não afetam a semântica do código.

## Example

O código a seguir produz este diagnóstico porque os parênteses em torno
da expressão binária não são necessários:

```dart
int f(int a, int b) => [!(a + b)!];
```

## Common fixes

Remova os parênteses desnecessários:

```dart
int f(int a, int b) => a + b;
```
