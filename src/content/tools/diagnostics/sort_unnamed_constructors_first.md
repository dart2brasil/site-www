---
title: sort_unnamed_constructors_first
description: >-
  Details about the sort_unnamed_constructors_first
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_unnamed_constructors_first"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Invalid location for the unnamed constructor._

## Descrição

O analisador produz este diagnóstico quando an unnamed constructor appears
after a named constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the unnamed
constructor is after the named construtor:

```dart
class C {
  C.named();

  [!C!]();
}
```

## Correções comuns

Move the unnamed constructor before any other construtores:

```dart
class C {
  C();

  C.named();
}
```
