---
title: avoid_dynamic_calls
description: >-
  Details about the avoid_dynamic_calls
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_dynamic_calls"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Method invocation or property access on a 'dynamic' target._

## Descrição

O analisador produz este diagnóstico quando a member of a class is accessed
on an expression whose type is `dynamic`.

## Exemplo

O código a seguir produz este diagnóstico porque the getter `length` is
being invoked on `s`, which has the type `dynamic`:

```dart
void f(dynamic s) {
  [!s!].length;
}
```

## Correções comuns

Provide enough type information that the expression has a type other than
`dynamic`:

```dart
void f(String s) {
  s.length;
}
```
