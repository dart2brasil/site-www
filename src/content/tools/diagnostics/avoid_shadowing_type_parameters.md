---
title: avoid_shadowing_type_parameters
description: >-
  Details about the avoid_shadowing_type_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_shadowing_type_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The type parameter '{0}' shadows a type parameter from the enclosing {1}._

## Descrição

O analisador produz este diagnóstico quando a type parameter shadows a type
parameter from an enclosing declaration.

Shadowing a type parameter with a different type parameter can lead to
subtle bugs that are difficult to debug.

## Exemplo

O código a seguir produz este diagnóstico porque the type parameter `T`
defined by the method `m` shadows the type parameter `T` defined by the
class `C`:

```dart
class C<T> {
  void m<[!T!]>() {}
}
```

## Correções comuns

Rename one of the type parameters:

```dart
class C<T> {
  void m<S>() {}
}
```
