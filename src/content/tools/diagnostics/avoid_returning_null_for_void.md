---
ia-translate: true
title: avoid_returning_null_for_void
description: >-
  Detalhes sobre o diagnóstico avoid_returning_null_for_void
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_returning_null_for_void"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não retorne 'null' de uma função com tipo de retorno 'void'._

_Não retorne 'null' de um método com tipo de retorno 'void'._

## Description

O analisador produz este diagnóstico quando uma função que tem um tipo de
retorno `void` explicitamente retorna `null`.

## Example

O código a seguir produz este diagnóstico porque há um
retorno explícito de `null` em uma função `void`:

```dart
void f() {
  [!return null;!]
}
```

## Common fixes

Remova o `null` explícito desnecessário:

```dart
void f() {
  return;
}
```
