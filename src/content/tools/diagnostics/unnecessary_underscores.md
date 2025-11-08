---
ia-translate: true
title: unnecessary_underscores
description: "Detalhes sobre o diagnóstico unnecessary_underscores produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_underscores"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de múltiplos underscores._

## Description

O analisador produz este diagnóstico quando uma variável não usada é nomeada
com múltiplos underscores (por exemplo `__`). Uma única variável wildcard `_`
pode ser usada em vez disso.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `__` não é usado:

```dart
void function(int [!__!]) { }
```

## Common fixes

Substitua o nome por um único underscore:

```dart
void function(int _) { }
```
