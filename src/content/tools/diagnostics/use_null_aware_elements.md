---
ia-translate: true
title: use_null_aware_elements
description: "Detalhes sobre o diagnóstico use_null_aware_elements produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_null_aware_elements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use o marcador null-aware '?' em vez de uma verificação de null via um 'if'._

## Descrição

O analisador produz este diagnóstico quando uma verificação de null é usada em vez
de um marcador null-aware dentro de um literal de coleção.

## Exemplo

O código a seguir produz este diagnóstico porque uma verificação de null é usada
para decidir se `x` deve ser inserido na lista, enquanto o
marcador null-aware '?' seria menos frágil e menos verboso.

```dart
f(int? x) => [[!if!] (x != null) x];
```

## Correções comuns

Substitua a verificação de null pelo marcador null-aware '?':

```dart
f(int? x) => [?x];
```
