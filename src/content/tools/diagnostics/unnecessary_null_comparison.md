---
title: unnecessary_null_comparison
description: >-
  Details about the unnecessary_null_comparison
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The operand can't be 'null', so the condition is always 'false'._

_The operand can't be 'null', so the condition is always 'true'._

_The operand must be 'null', so the condition is always 'false'._

_The operand must be 'null', so the condition is always 'true'._

## Descrição

O analisador produz este diagnóstico quando it finds an equality comparison
(either `==` or `!=`) with one operand of `null` and the other operand
can't be `null`. Such comparisons are always either `true` or `false`, so
they serve no purpose.

## Exemplos

O código a seguir produz este diagnóstico porque `x` can never be
`null`, so the comparison always evaluates to `true`:

```dart
void f(int x) {
  if (x [!!= null!]) {
    print(x);
  }
}
```

O código a seguir produz este diagnóstico porque `x` can never be
`null`, so the comparison always evaluates to `false`:

```dart
void f(int x) {
  if (x [!== null!]) {
    throw ArgumentError("x can't be null");
  }
}
```

## Correções comuns

If the other operand should be able to be `null`, then change the type of
the operand:

```dart
void f(int? x) {
  if (x != null) {
    print(x);
  }
}
```

If the other operand really can't be `null`, then remove the condition:

```dart
void f(int x) {
  print(x);
}
```
