---
ia-translate: true
title: avoid_single_cascade_in_expression_statements
description: >-
  Detalhes sobre o diagnóstico avoid_single_cascade_in_expression_statements
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_single_cascade_in_expression_statements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Expressão cascade desnecessária._

## Description

O analisador produz este diagnóstico quando um único operador cascade é
usado e o valor da expressão não está sendo usado para nada (como
ser atribuído a uma variável ou ser passado como argumento).

## Example

O código a seguir produz este diagnóstico porque o valor da
expressão cascade `s..length` não está sendo usado:

```dart
void f(String s) {
  [!s..length!];
}
```

## Common fixes

Substitua o operador cascade por um operador de acesso simples:

```dart
void f(String s) {
  s.length;
}
```
