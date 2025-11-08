---
title: void_checks
description: >-
  Details about the void_checks
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/void_checks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Assignment to a variable of type 'void'._

## Descrição

O analisador produz este diagnóstico quando a value is assigned to a
variable of type `void`.

It isn't possible to access the value of such a variable, so the
assignment has no value.

## Exemplo

O código a seguir produz este diagnóstico porque the field `value` has
the type `void`, but a value is being assigned to it:

```dart
class A<T> {
  T? value;
}

void f(A<void> a) {
  [!a.value = 1!];
}
```

O código a seguir produz este diagnóstico porque the type of the
parameter `p` in the method `m` is `void`, but a value is being assigned
to it in the invocation:

```dart
class A<T> {
  void m(T p) { }
}

void f(A<void> a) {
  a.m([!1!]);
}
```

## Correções comuns

If the type of the variable is incorrect, then change the type of the
variable:

```dart
class A<T> {
  T? value;
}

void f(A<int> a) {
  a.value = 1;
}
```

If the type of the variable is correct, then remove the assignment:

```dart
class A<T> {
  T? value;
}

void f(A<void> a) {}
```
