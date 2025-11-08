---
title: prefer_typing_uninitialized_variables
description: >-
  Details about the prefer_typing_uninitialized_variables
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_typing_uninitialized_variables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_An uninitialized field should have an explicit type annotation._

_An uninitialized variable should have an explicit type annotation._

## Descrição

O analisador produz este diagnóstico quando a variable without an
initializer não tem uma explicit type annotation.

Without either a type annotation or an initializer, a variable has the
type `dynamic`, which allows any value to be assigned to the variable,
often causing hard to identify bugs.

## Exemplo

O código a seguir produz este diagnóstico porque the variable `r`
doesn't have either a type annotation or an initializer:

```dart
Object f() {
  var [!r!];
  r = '';
  return r;
}
```

## Correções comuns

If the variable can be initialized, then add an initializer:

```dart
Object f() {
  var r = '';
  return r;
}
```

If the variable can't be initialized, then add an explicit type
annotation:

```dart
Object f() {
  String r;
  r = '';
  return r;
}
```
