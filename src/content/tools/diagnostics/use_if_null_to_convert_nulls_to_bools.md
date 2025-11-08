---
title: use_if_null_to_convert_nulls_to_bools
description: >-
  Details about the use_if_null_to_convert_nulls_to_bools
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_if_null_to_convert_nulls_to_bools"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use an if-null operator to convert a 'null' to a 'bool'._

## Descrição

O analisador produz este diagnóstico quando a nullable `bool`-valued
expression is compared (using `==` or `!=`) to a boolean literal.

## Exemplo

O código a seguir produz este diagnóstico porque the nullable boolean
variable `b` is compared to `true`:

```dart
void f(bool? b) {
  if ([!b == true!]) {
    // Treats `null` as `false`.
  }
}
```

## Correções comuns

Rewrite the condition to use `??` instead:

```dart
void f(bool? b) {
  if (b ?? false) {
    // Treats `null` as `false`.
  }
}
```
