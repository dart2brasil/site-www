---
title: unnecessary_null_aware_assignments
description: >-
  Details about the unnecessary_null_aware_assignments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_aware_assignments"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary assignment of 'null'._

## Descrição

O analisador produz este diagnóstico quando the right-hand side of a
null-aware assignment is the `null` literal.

## Exemplo

O código a seguir produz este diagnóstico porque the null aware
operator is being used to assign `null` to `s` when `s` is already `null`:

```dart
void f(String? s) {
  [!s ??= null!];
}
```

## Correções comuns

If a non-null value should be assigned to the left-hand operand, then
change the right-hand side:

```dart
void f(String? s) {
  s ??= '';
}
```

If there is no non-null value to assign to the left-hand operand, then
remove the assignment:

```dart
void f(String? s) {
}
```
