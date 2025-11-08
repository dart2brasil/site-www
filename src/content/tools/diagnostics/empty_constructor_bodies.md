---
title: empty_constructor_bodies
description: >-
  Details about the empty_constructor_bodies
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_constructor_bodies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Empty constructor bodies should be written using a ';' rather than '{}'._

## Descrição

O analisador produz este diagnóstico quando a constructor has an empty
block body.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor for
`C` has a block body that is empty:

```dart
class C {
  C() [!{}!]
}
```

## Correções comuns

Replace the block with a semicolon:

```dart
class C {
  C();
}
```
