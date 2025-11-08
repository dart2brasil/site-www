---
ia-translate: true
title: non_bool_operand
description: >-
  Detalhes sobre o diagnóstico non_bool_operand
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The operands of the operator '{0}' must be assignable to 'bool'._

## Description

O analisador produz este diagnóstico quando um dos operandos dos operadores
`&&` ou `||` não possui o tipo `bool`.

## Example

O código a seguir produz este diagnóstico porque `a` não é um valor
Boolean:

```dart
int a = 3;
bool b = [!a!] || a > 1;
```

## Common fixes

Mude o operando para um valor Boolean:

```dart
int a = 3;
bool b = a == 0 || a > 1;
```
