---
ia-translate: true
title: always_put_control_body_on_new_line
description: >-
  Detalhes sobre o diagnóstico always_put_control_body_on_new_line
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_put_control_body_on_new_line"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Statement should be on a separate line._

## Description

O analisador produz este diagnóstico quando o código controlado por uma
instrução de fluxo de controle (`if`, `for`, `while` ou `do`) está na mesma linha
que a instrução de fluxo de controle.

## Example

O código a seguir produz este diagnóstico porque a instrução `return`
está na mesma linha que o `if` que controla se o `return` será
executado:

```dart
void f(bool b) {
  if (b) [!return!];
}
```

## Common fixes

Coloque a instrução controlada em uma linha separada e indentada:

```dart
void f(bool b) {
  if (b)
    return;
}
```
