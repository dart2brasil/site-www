---
ia-translate: true
title: prefer_conditional_assignment
description: >-
  Detalhes sobre o diagnóstico prefer_conditional_assignment
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_conditional_assignment"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_A instrução 'if' poderia ser substituída por uma atribuição null-aware._

## Description

O analisador produz este diagnóstico quando uma atribuição a uma variável é
condicional com base em se a variável tem o valor `null` e o
operador `??=` poderia ser usado em vez disso.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `s` está
sendo comparado a `null` para determinar se deve atribuir um
valor diferente:

```dart
int f(String? s) {
  [!if (s == null) {!]
    [!s = '';!]
  [!}!]
  return s.length;
}
```

## Common fixes

Use o operador `??=` em vez de uma instrução `if` explícita:

```dart
int f(String? s) {
  s ??= '';
  return s.length;
}
```
