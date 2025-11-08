---
title: recursive_getters
description: >-
  Details about the recursive_getters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_The getter '{0}' recursively returns itself._

## Descrição

O analisador produz este diagnóstico quando a getter invokes itself,
resulting in an infinite loop.

## Exemplo

O código a seguir produz este diagnóstico porque the getter `count`
invokes itself:

```dart
class C {
  int _count = 0;

  int get [!count!] => count;
}
```

## Correções comuns

Change the getter to not invoke itself:

```dart
class C {
  int _count = 0;

  int get count => _count;
}
```
