---
title: prefer_final_fields
description: >-
  Details about the prefer_final_fields
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_fields"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The private field {0} could be 'final'._

## Descrição

O analisador produz este diagnóstico quando a private field is only
assigned one time. The field can be initialized in multiple constructors
and still be flagged because only one of those constructors can ever run.

## Exemplo

O código a seguir produz este diagnóstico porque the field `_f` is only
assigned one time, in the field's initializer:

```dart
class C {
  int [!_f = 1!];

  int get f => _f;
}
```

## Correções comuns

Mark the field `final`:

```dart
class C {
  final int _f = 1;

  int get f => _f;
}
```
