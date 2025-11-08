---
title: unnecessary_this
description: >-
  Details about the unnecessary_this
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_this"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary 'this.' qualifier._

## Descrição

O analisador produz este diagnóstico quando the keyword `this` is used to
access a member that isn't shadowed.

## Exemplo

O código a seguir produz este diagnóstico porque the use of `this` to
access the field `_f` isn't necessary:

```dart
class C {
  int _f = 2;

  int get f => [!this!]._f;
}
```

## Correções comuns

Remove the `this.`:

```dart
class C {
  int _f = 2;

  int get f => _f;
}
```
