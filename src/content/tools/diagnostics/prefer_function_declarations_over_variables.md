---
ia-translate: true
title: prefer_function_declarations_over_variables
description: >-
  Detalhes sobre o diagnóstico prefer_function_declarations_over_variables
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_function_declarations_over_variables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use uma declaração de função em vez de uma atribuição de variável para vincular uma função a um nome._

## Description

O analisador produz este diagnóstico quando um closure é atribuído a uma
variável local e a variável local não é reatribuída em nenhum lugar.

## Example

O código a seguir produz este diagnóstico porque a variável local `f`
é inicializada como um closure e não é atribuída nenhum outro valor:

```dart
void g() {
  var [!f = (int i) => i * 2!];
  f(1);
}
```

## Common fixes

Substitua a variável local por uma função local:

```dart
void g() {
  int f(int i) => i * 2;
  f(1);
}
```
