---
ia-translate: true
title: sort_unnamed_constructors_first
description: "Detalhes sobre o diagnóstico sort_unnamed_constructors_first produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_unnamed_constructors_first"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Localização inválida para o construtor sem nome._

## Descrição

O analisador produz este diagnóstico quando um construtor sem nome aparece
depois de um construtor nomeado.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor sem nome
está depois do construtor nomeado:

```dart
class C {
  C.named();

  [!C!]();
}
```

## Correções comuns

Mova o construtor sem nome antes de quaisquer outros construtores:

```dart
class C {
  C();

  C.named();
}
```
