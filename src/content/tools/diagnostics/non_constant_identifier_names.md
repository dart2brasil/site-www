---
ia-translate: true
title: non_constant_identifier_names
description: >-
  Detalhes sobre o diagnóstico non_constant_identifier_names
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/non_constant_identifier_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The variable name '{0}' isn't a lowerCamelCase identifier._

## Description

O analisador produz este diagnóstico quando o nome de um membro de classe,
declaração top-level, variável, parâmetro, parâmetro nomeado, ou
construtor nomeado que não é declarado como `const`, não usa a
convenção lowerCamelCase.

## Example

O código a seguir produz este diagnóstico porque a variável top-level
`Count` não começa com uma letra minúscula:

```dart
var [!Count!] = 0;
```

## Common fixes

Mude o nome na declaração para seguir a convenção
lowerCamelCase:

```dart
var count = 0;
```
