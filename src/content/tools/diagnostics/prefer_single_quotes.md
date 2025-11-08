---
ia-translate: true
title: prefer_single_quotes
description: >-
  Detalhes sobre o diagnóstico prefer_single_quotes
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_single_quotes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de aspas duplas._

## Description

O analisador produz este diagnóstico quando um literal de string usa aspas
duplas (`"`) quando poderia usar aspas simples (`'`) sem precisar de escapes
extras e sem prejudicar a legibilidade.

## Example

O código a seguir produz este diagnóstico porque o literal de string
usa aspas duplas mas não precisa:

```dart
void f(String name) {
  print([!"Hello $name"!]);
}
```

## Common fixes

Use aspas simples no lugar de aspas duplas:

```dart
void f(String name) {
  print('Hello $name');
}
```
