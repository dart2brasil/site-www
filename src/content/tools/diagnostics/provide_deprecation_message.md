---
title: provide_deprecation_message
description: >-
  Details about the provide_deprecation_message
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/provide_deprecation_message"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing a deprecation message._

## Descrição

O analisador produz este diagnóstico quando a `deprecated` annotation is
used instead of the `Deprecated` annotation.

## Exemplo

O código a seguir produz este diagnóstico porque the function `f` is
annotated with `deprecated`:

```dart
[!@deprecated!]
void f() {}
```

## Correções comuns

Convert the code to use the longer form:

```dart
@Deprecated('Use g instead. Will be removed in 4.0.0.')
void f() {}
```
