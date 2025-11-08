---
ia-translate: true
title: constant_identifier_names
description: "Detalhes sobre o diagnóstico constant_identifier_names produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/constant_identifier_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome da constante '{0}' não é um identificador lowerCamelCase._

## Descrição

O analisador produz este diagnóstico quando o nome de uma constante não
segue a convenção de nomenclatura lowerCamelCase.

## Exemplo

O código a seguir produz este diagnóstico porque o nome da
variável de nível superior não é um identificador lowerCamelCase:

```dart
const [!EMPTY_STRING!] = '';
```

## Correções comuns

Reescreva o nome para seguir a convenção de nomenclatura lowerCamelCase:

```dart
const emptyString = '';
```
