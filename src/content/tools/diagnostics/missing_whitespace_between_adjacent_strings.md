---
title: missing_whitespace_between_adjacent_strings
description: "Detalhes sobre o diagnóstico missing_whitespace_between_adjacent_strings produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/missing_whitespace_between_adjacent_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Espaço em branco missing entre strings adjacentes._

## Description

O analisador produz este diagnóstico para um par de literais de string
adjacentes a menos que a string da esquerda termine em espaço em branco ou a
string da direita comece com espaço em branco.

## Example

O código a seguir produz este diagnóstico porque nem a string da esquerda nem
a string da direita inclui um espaço para separar as palavras que serão
unidas:

```dart
var s =
  [!'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed'!]
  'do eiusmod tempor incididunt ut labore et dolore magna';
```

## Common fixes

Adicione espaço em branco no final do literal da esquerda ou no início do
literal da direita:

```dart
var s =
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed '
  'do eiusmod tempor incididunt ut labore et dolore magna';
```
