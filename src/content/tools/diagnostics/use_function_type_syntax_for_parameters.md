---
ia-translate: true
title: use_function_type_syntax_for_parameters
description: >-
  Detalhes sobre o diagnóstico use_function_type_syntax_for_parameters
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_function_type_syntax_for_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a sintaxe de tipo de função genérica para declarar o parâmetro '{0}'._

## Descrição

O analisador produz este diagnóstico quando a sintaxe de parâmetro com valor de função
no estilo antigo é usada.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro com valor de função
`f` é declarado usando uma sintaxe no estilo antigo:

```dart
void g([!bool f(String s)!]) {}
```

## Correções comuns

Use a sintaxe de tipo de função genérica para declarar o parâmetro:

```dart
void g(bool Function(String) f) {}
```
