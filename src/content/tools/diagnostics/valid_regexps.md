---
ia-translate: true
title: valid_regexps
description: "Detalhes sobre o diagnóstico valid_regexps produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/valid_regexps"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Sintaxe de expressão regular inválida._

## Description

O analisador produz este diagnóstico quando a string passada para o
construtor padrão da classe `RegExp` não contém uma expressão regular
válida.

Uma expressão regular criada com sintaxe inválida lançará uma
`FormatException` em tempo de execução.

## Example

O código a seguir produz este diagnóstico porque a expressão regular
não é válida:

```dart
var r = RegExp([!r'('!]);
```

## Common fixes

Corrija a expressão regular:

```dart
var r = RegExp(r'\(');
```
