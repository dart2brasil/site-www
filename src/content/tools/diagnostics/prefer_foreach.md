---
title: prefer_foreach
description: >-
  Details about the prefer_foreach
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_foreach"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'forEach' and a tear-off rather than a 'for' loop to apply a function to every element._

## Descrição

O analisador produz este diagnóstico quando a `for` loop is used to operate
on every member of a collection and the method `forEach` could be used
instead.

## Exemplo

O código a seguir produz este diagnóstico porque a `for` loop is being
used to invoke a single function for each key in `m`:

```dart
void f(Map<String, int> m) {
  [!for (final key in m.keys) {!]
    [!print(key);!]
  [!}!]
}
```

## Correções comuns

Replace the for loop with an invocation of `forEach`:

```dart
void f(Map<String, int> m) {
  m.keys.forEach(print);
}
```
