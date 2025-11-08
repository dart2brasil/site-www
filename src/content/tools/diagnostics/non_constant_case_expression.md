---
ia-translate: true
title: non_constant_case_expression
description: >-
  Detalhes sobre o diagnóstico non_constant_case_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Case expressions must be constant._

## Description

O analisador produz este diagnóstico quando a expressão em uma cláusula
`case` não é uma expressão constante.

## Example

O código a seguir produz este diagnóstico porque `j` não é uma constante:

```dart
void f(int i, int j) {
  switch (i) {
    case [!j!]:
      // ...
      break;
  }
}
```

## Common fixes

Torne a expressão uma expressão constante, ou reescreva o comando `switch`
como uma sequência de comandos `if`:

```dart
void f(int i, int j) {
  if (i == j) {
    // ...
  }
}
```
