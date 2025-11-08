---
title: non_constant_case_expression
description: >-
  Details about the non_constant_case_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Case expressions must be constant._

## Descrição

O analisador produz este diagnóstico quando the expression in a `case`
clause isn't a constant expression.

## Exemplo

O código a seguir produz este diagnóstico porque `j` isn't a constant:

```dart
void f(int i, int j) {
  switch (i) {
    case [!j!]:
      // ...
      break;
  }
}
```

## Correções comuns

Either make the expression a constant expression, or rewrite the `switch`
statement as a sequence of `if` statements:

```dart
void f(int i, int j) {
  if (i == j) {
    // ...
  }
}
```
