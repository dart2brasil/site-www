---
ia-translate: true
title: dead_null_aware_expression
description: "Detalhes sobre o diagnóstico dead_null_aware_expression produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O operando esquerdo não pode ser null, então o operando direito nunca é executado._

## Description

O analisador produz este diagnóstico em dois casos.

O primeiro é quando o operando esquerdo de um operador `??` não pode ser `null`.
O operando direito é avaliado apenas se o operando esquerdo tem o valor
`null`, e como o operando esquerdo não pode ser `null`, o operando direito
nunca é avaliado.

O segundo é quando o lado esquerdo de uma atribuição usando o operador `??=`
não pode ser `null`. O lado direito é avaliado apenas se o lado esquerdo tem o
valor `null`, e como o lado esquerdo não pode ser `null`, o lado direito nunca
é avaliado.

## Examples

O código a seguir produz este diagnóstico porque `x` não pode ser `null`:

```dart
int f(int x) {
  return x ?? [!0!];
}
```

O código a seguir produz este diagnóstico porque `f` não pode ser `null`:

```dart
class C {
  int f = -1;

  void m(int x) {
    f ??= [!x!];
  }
}
```

## Common fixes

Se o diagnóstico é reportado para um operador `??`, então remova o operador `??`
e o operando direito:

```dart
int f(int x) {
  return x;
}
```

Se o diagnóstico é reportado para uma atribuição, e a atribuição não é
necessária, então remova a atribuição:

```dart
class C {
  int f = -1;

  void m(int x) {
  }
}
```

Se a atribuição é necessária, mas deve ser baseada em uma condição diferente,
então reescreva o código para usar `=` e a condição diferente:

```dart
class C {
  int f = -1;

  void m(int x) {
    if (f < 0) {
      f = x;
    }
  }
}
```
