---
ia-translate: true
title: use_truncating_division
description: >-
  Detalhes sobre o diagnóstico use_truncating_division
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_truncating_division"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use divisão truncada._

## Descrição

O analisador produz este diagnóstico quando o resultado de dividir dois
números é convertido para um inteiro usando `toInt`.

Dart tem um operador de divisão inteira embutido que é tanto mais eficiente
quanto mais conciso.

## Exemplo

O código a seguir produz este diagnóstico porque o resultado de dividir
`x` e `y` é convertido para um inteiro usando `toInt`:

```dart
int divide(int x, int y) => [!(x / y).toInt()!];
```

## Correções comuns

Use o operador de divisão inteira (`~/`):

```dart
int divide(int x, int y) => x ~/ y;
```
