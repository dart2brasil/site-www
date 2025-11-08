---
title: prefer_if_null_operators
description: >-
  Details about the prefer_if_null_operators
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_if_null_operators"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the '??' operator rather than '?:' when testing for 'null'._

## Descrição

O analisador produz este diagnóstico quando a conditional expression (using
the `?:` operator) is used to select a different value when a local
variable is `null`.

## Exemplo

O código a seguir produz este diagnóstico porque the variable `s` is
being compared to `null` so that a different value can be returned when
`s` is `null`:

```dart
String f(String? s) => [!s == null ? '' : s!];
```

## Correções comuns

Use the if-null operator instead:

```dart
String f(String? s) => s ?? '';
```
