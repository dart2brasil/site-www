---
title: non_bool_operand
description: >-
  Details about the non_bool_operand
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The operands of the operator '{0}' must be assignable to 'bool'._

## Descrição

O analisador produz este diagnóstico quando one of the operands of either
the `&&` or `||` operator doesn't have the type `bool`.

## Exemplo

O código a seguir produz este diagnóstico porque `a` isn't a Boolean
value:

```dart
int a = 3;
bool b = [!a!] || a > 1;
```

## Correções comuns

Change the operand to a Boolean value:

```dart
int a = 3;
bool b = a == 0 || a > 1;
```
