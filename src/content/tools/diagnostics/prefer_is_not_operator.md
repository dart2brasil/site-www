---
title: prefer_is_not_operator
description: >-
  Details about the prefer_is_not_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_not_operator"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the 'is!' operator rather than negating the value of the 'is' operator._

## Descrição

O analisador produz este diagnóstico quando the prefix `!` operator is used
to negate the result of an `is` test.

## Exemplo

O código a seguir produz este diagnóstico porque the result of testing
to see whether `o` is a `String` is negated using the prefix `!` operator:

```dart
String f(Object o) {
  if ([!!(o is String)!]) {
    return o.toString();
  }
  return o;
}
```

## Correções comuns

Use the `is!` operator instead:

```dart
String f(Object o) {
  if (o is! String) {
    return o.toString();
  }
  return o;
}
```
