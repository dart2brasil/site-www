---
ia-translate: true
title: sort_constructors_first
description: >-
  Detalhes sobre o diagnóstico sort_constructors_first
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_constructors_first"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Declarações de construtores devem vir antes de declarações não-construtoras._

## Descrição

O analisador produz este diagnóstico quando uma declaração de construtor é
precedida por uma ou mais declarações não-construtoras.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor para
`C` aparece depois do método `m`:

```dart
class C {
  void m() {}

  [!C!]();
}
```

## Correções comuns

Mova todas as declarações de construtores antes de quaisquer outras declarações:

```dart
class C {
  C();

  void m() {}
}
```
