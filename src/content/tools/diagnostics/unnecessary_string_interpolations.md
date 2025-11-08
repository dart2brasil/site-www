---
ia-translate: true
title: unnecessary_string_interpolations
description: >-
  Detalhes sobre o diagnóstico unnecessary_string_interpolations
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_string_interpolations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de interpolação de string._

## Description

O analisador produz este diagnóstico quando um literal de string contém uma
única interpolação de uma variável com valor `String` e nenhum outro
caractere.

## Example

O código a seguir produz este diagnóstico porque o literal de string
contém uma única interpolação e não contém nenhum caractere fora
da interpolação:

```dart
String f(String s) => [!'$s'!];
```

## Common fixes

Substitua o literal de string pelo conteúdo da interpolação:

```dart
String f(String s) => s;
```
