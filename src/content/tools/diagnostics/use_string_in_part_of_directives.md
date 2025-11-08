---
ia-translate: true
title: use_string_in_part_of_directives
description: >-
  Detalhes sobre o diagnóstico use_string_in_part_of_directives
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_string_in_part_of_directives"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_A diretiva part-of usa um nome de biblioteca._

## Descrição

O analisador produz este diagnóstico quando uma diretiva `part of` usa um
nome de biblioteca para se referir à biblioteca da qual a parte faz parte.

## Exemplo

Dado um arquivo chamado `lib.dart` que contém o seguinte:

```dart
library lib;

part 'test.dart';
```

O código a seguir produz este diagnóstico porque a diretiva `part of`
usa o nome da biblioteca em vez do URI da biblioteca
da qual faz parte:

```dart
[!part of lib;!]
```

## Correções comuns

Use um URI para referenciar a biblioteca:

```dart
part of 'lib.dart';
```
