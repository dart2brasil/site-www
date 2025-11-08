---
ia-translate: true
title: use_raw_strings
description: "Detalhes sobre o diagnóstico use_raw_strings produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_raw_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use uma raw string para evitar usar escapes._

## Descrição

O analisador produz este diagnóstico quando um literal de string contendo
escapes, e sem interpolações, poderia ser marcado como sendo raw para
evitar a necessidade dos escapes.

## Exemplo

O código a seguir produz este diagnóstico porque a string contém
caracteres escapados que não precisariam ser escapados se a string for
transformada em uma raw string:

```dart
var s = [!'A string with only \\ and \$'!];
```

## Correções comuns

Marque a string como sendo raw e remova as barras invertidas desnecessárias:

```dart
var s = r'A string with only \ and $';
```
