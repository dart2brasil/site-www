---
ia-translate: true
title: duplicate_pattern_assignment_variable
description: "Detalhes sobre o diagnóstico duplicate_pattern_assignment_variable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável '{0}' já foi atribuída neste pattern._

## Description

O analisador produz este diagnóstico quando uma única variável de pattern é
atribuída um valor mais de uma vez na mesma atribuição de pattern.

## Example

O código a seguir produz este diagnóstico porque a variável `a` é
atribuída duas vezes no pattern `(a, a)`:

```dart
int f((int, int) r) {
  int a;
  (a, [!a!]) = r;
  return a;
}
```

## Common fixes

Se você precisa capturar todos os valores, então use uma variável única para
cada um dos subpatterns sendo correspondidos:

```dart
int f((int, int) r) {
  int a, b;
  (a, b) = r;
  return a + b;
}
```

Se alguns dos valores não precisam ser capturados, então use um
pattern wildcard `_` para evitar ter que vincular o valor a uma variável:

```dart
int f((int, int) r) {
  int a;
  (_, a) = r;
  return a;
}
```
