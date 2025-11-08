---
ia-translate: true
title: recursive_getters
description: "Detalhes sobre o diagnóstico recursive_getters produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/recursive_getters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O getter '{0}' retorna recursivamente a si mesmo._

## Description

O analisador produz este diagnóstico quando um getter invoca a si mesmo,
resultando em um loop infinito.

## Example

O código a seguir produz este diagnóstico porque o getter `count`
invoca a si mesmo:

```dart
class C {
  int _count = 0;

  int get [!count!] => count;
}
```

## Common fixes

Altere o getter para não invocar a si mesmo:

```dart
class C {
  int _count = 0;

  int get count => _count;
}
```
