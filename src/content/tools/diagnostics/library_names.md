---
title: library_names
description: "Detalhes sobre o diagnóstico library_names produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome da library '{0}' não é um identificador lower\_case\_with\_underscores._

## Descrição

O analisador produz este diagnóstico quando o nome de uma library não
usa a convenção de nomenclatura lower_case_with_underscores.

## Exemplo

O código a seguir produz este diagnóstico porque o nome da library
`libraryName` não é um identificador lower_case_with_underscores:

```dart
library [!libraryName!];
```

## Correções comuns

Se o nome da library não é necessário, então remova o nome da library:

```dart
library;
```

Se o nome da library é necessário, então converta-o para usar a
convenção de nomenclatura lower_case_with_underscores:

```dart
library library_name;
```
