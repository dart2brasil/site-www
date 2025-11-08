---
title: await_only_futures
description: >-
  Details about the await_only_futures
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/await_only_futures"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uses 'await' on an instance of '{0}', which is not a subtype of 'Future'._

## Descrição

O analisador produz este diagnóstico quando the expression after `await`
has any type other than `Future<T>`, `FutureOr<T>`, `Future<T>?`,
`FutureOr<T>?` or `dynamic`.

An exception is made for the expression `await null` because it is a
common way to introduce a microtask delay.

Unless the expression can produce a `Future`, the `await` is unnecessary
and can cause a reader to assume a level of asynchrony that doesn't exist.

## Exemplo

O código a seguir produz este diagnóstico porque the expression after
`await` has the type `int`:

```dart
void f() async {
  [!await!] 23;
}
```

## Correções comuns

Remove the `await`:

```dart
void f() async {
  23;
}
```
