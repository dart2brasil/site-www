---
title: prefer_generic_function_type_aliases
description: >-
  Details about the prefer_generic_function_type_aliases
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_Use the generic function type syntax in 'typedef's._

## Descrição

O analisador produz este diagnóstico quando a typedef is written using the
older syntax for function type aliases in which the name being declared is
embedded in the function type.

## Exemplo

O código a seguir produz este diagnóstico porque it uses the older
syntax:

```dart
typedef void [!F!]<T>();
```

## Correções comuns

Rewrite the typedef to use the newer syntax:

```dart
typedef F<T> = void Function();
```
