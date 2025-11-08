---
ia-translate: true
title: type_annotate_public_apis
description: "Detalhes sobre o diagnóstico type_annotate_public_apis produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/type_annotate_public_apis"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Anotação de type ausente em uma API pública._

## Descrição

O analisador produz este diagnóstico quando a declaração de parte da
API pública de um pacote não possui anotações de tipo explícitas.

## Exemplo

O código a seguir produz este diagnóstico porque a função `f`
não possui um tipo de retorno explícito e os parâmetros `x` e `y` não
possuem tipos explícitos:

```dart
[!f!](x, y) => '';
```

## Correções comuns

Adicione anotações de tipo à API:

```dart
String f(int x, int y) => '';
```
