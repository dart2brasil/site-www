---
title: sort_constructors_first
description: >-
  Details about the sort_constructors_first
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_constructors_first"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Constructor declarations should be before non-constructor declarations._

## Descrição

O analisador produz este diagnóstico quando a constructor declaration is
preceded by one or more non-constructor declarations.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor for
`C` appears after the method `m`:

```dart
class C {
  void m() {}

  [!C!]();
}
```

## Correções comuns

Move all of the constructor declarations before any other declarations:

```dart
class C {
  C();

  void m() {}
}
```
