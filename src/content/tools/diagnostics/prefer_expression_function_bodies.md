---
ia-translate: true
title: prefer_expression_function_bodies
description: >-
  Detalhes sobre o diagnóstico prefer_expression_function_bodies
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Uso desnecessário de um corpo de função em bloco._

## Description

O analisador produz este diagnóstico quando o corpo de uma função consiste
em uma única instrução return com uma expressão.

## Example

O código a seguir produz este diagnóstico porque o corpo de `f` tem uma
única instrução return:

```dart
int f() [!{!]
  [!return 0;!]
[!}!]
```

## Common fixes

Se o corpo está completo, substitua o corpo por um corpo de expressão:

```dart
int f() => 0;
```

Se o corpo não está completo, adicione as instruções faltantes.
