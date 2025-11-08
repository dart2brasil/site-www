---
ia-translate: true
title: prefer_asserts_with_message
description: >-
  Detalhes sobre o diagnóstico prefer_asserts_with_message
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_asserts_with_message"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Falta uma mensagem em um assert._

## Description

O analisador produz este diagnóstico quando uma instrução assert não
tem uma mensagem.

## Example

O código a seguir produz este diagnóstico porque não há mensagem
na instrução assert:

```dart
void f(String s) {
  [!assert(s.isNotEmpty);!]
}
```

## Common fixes

Adicione uma mensagem à instrução assert:

```dart
void f(String s) {
  assert(s.isNotEmpty, 'The argument must not be empty.');
}
```
