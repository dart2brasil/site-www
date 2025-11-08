---
ia-translate: true
title: avoid_dynamic_calls
description: "Detalhes sobre o diagnóstico avoid_dynamic_calls produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_dynamic_calls"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Invocação de método ou acesso a propriedade em um alvo 'dynamic'._

## Description

O analisador produz este diagnóstico quando um membro de uma classe é acessado
em uma expressão cujo tipo é `dynamic`.

## Example

O código a seguir produz este diagnóstico porque o getter `length` está
sendo invocado em `s`, que possui o tipo `dynamic`:

```dart
void f(dynamic s) {
  [!s!].length;
}
```

## Common fixes

Forneça informação de tipo suficiente para que a expressão tenha um tipo diferente de
`dynamic`:

```dart
void f(String s) {
  s.length;
}
```
