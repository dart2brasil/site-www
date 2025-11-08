---
title: throw_in_finally
description: >-
  Details about the throw_in_finally
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/throw_in_finally"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use of '{0}' in 'finally' block._

## Descrição

O analisador produz este diagnóstico quando a `throw` statement is found
inside a `finally` block.

## Exemplo

O código a seguir produz este diagnóstico porque there is a `throw`
statement inside a `finally` block:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  } finally {
    [!throw 'error'!];
  }
}
```

## Correções comuns

Rewrite the code so that the `throw` statement isn't inside a `finally`
block:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  }
  throw 'error';
}
```
