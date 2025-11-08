---
ia-translate: true
title: use_named_constants
description: "Detalhes sobre o diagnóstico use_named_constants produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_named_constants"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a constante '{0}' em vez de um construtor retornando o mesmo objeto._

## Descrição

O analisador produz este diagnóstico quando uma constante é criada com o
mesmo valor que uma variável `const` conhecida.

## Exemplo

O código a seguir produz este diagnóstico porque existe um
campo `const` conhecido (`Duration.zero`) cujo valor é o mesmo que o
que a invocação do construtor avaliará:

```dart
Duration d = [!const Duration(seconds: 0)!];
```

## Correções comuns

Substitua a invocação do construtor por uma referência à variável `const`
conhecida:

```dart
Duration d = Duration.zero;
```
