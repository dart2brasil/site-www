---
title: unnecessary_non_null_assertion
description: >-
  Details about the unnecessary_non_null_assertion
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The '!' will have no effect because the receiver can't be null._

## Descrição

O analisador produz este diagnóstico quando the operand of the `!` operator
can't be `null`.

## Exemplo

O código a seguir produz este diagnóstico porque `x` can't be `null`:

```dart
int f(int x) {
  return x[!!!];
}
```

## Correções comuns

Remove the null check operator (`!`):

```dart
int f(int x) {
  return x;
}
```
