---
ia-translate: true
title: avoid_return_types_on_setters
description: "Detalhes sobre o diagnóstico avoid_return_types_on_setters produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_return_types_on_setters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Tipo de retorno desnecessário em um setter._

## Description

O analisador produz este diagnóstico quando um setter tem um tipo de retorno
explícito.

Setters nunca retornam um valor, então declarar o tipo de retorno de um é
redundante.

## Example

O código a seguir produz este diagnóstico porque o setter `s` tem um
tipo de retorno explícito (`void`):

```dart
[!void!] set s(int p) {}
```

## Common fixes

Remova o tipo de retorno:

```dart
set s(int p) {}
```
