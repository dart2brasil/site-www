---
ia-translate: true
title: camel_case_types
description: >-
  Detalhes sobre o diagnóstico camel_case_types
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/camel_case_types"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome do type '{0}' não é um identificador UpperCamelCase._

## Description

O analisador produz este diagnóstico quando o nome de um type (uma classe,
mixin, enum ou typedef) não usa a convenção de nomenclatura
'UpperCamelCase'.

## Example

O código a seguir produz este diagnóstico porque o nome da classe
não começa com uma letra maiúscula:

```dart
class [!c!] {}
```

## Common fixes

Renomeie o type para que ele tenha um nome válido:

```dart
class C {}
```
