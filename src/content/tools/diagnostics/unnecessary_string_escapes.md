---
ia-translate: true
title: unnecessary_string_escapes
description: >-
  Detalhes sobre o diagnóstico unnecessary_string_escapes
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_string_escapes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Escape desnecessário em literal de string._

## Description

O analisador produz este diagnóstico quando caracteres em uma string são
escapados quando escapá-los é desnecessário.

## Example

O código a seguir produz este diagnóstico porque aspas simples não
precisam ser escapadas dentro de strings delimitadas por aspas duplas:

```dart
var s = "Don[!\!]'t use a backslash here.";
```

## Common fixes

Remova as barras invertidas desnecessárias:

```dart
var s = "Don't use a backslash here.";
```
