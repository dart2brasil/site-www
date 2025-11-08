---
ia-translate: true
title: prefer_generic_function_type_aliases
description: >-
  Detalhes sobre o diagnóstico prefer_generic_function_type_aliases
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_generic_function_type_aliases"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a sintaxe de tipo de função genérica em 'typedef's._

## Description

O analisador produz este diagnóstico quando um typedef é escrito usando a
sintaxe mais antiga para aliases de tipo de função, na qual o nome sendo declarado é
incorporado no tipo de função.

## Example

O código a seguir produz este diagnóstico porque usa a sintaxe
mais antiga:

```dart
typedef void [!F!]<T>();
```

## Common fixes

Reescreva o typedef para usar a sintaxe mais nova:

```dart
typedef F<T> = void Function();
```
