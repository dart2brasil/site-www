---
title: not_binary_operator
description: >-
  Details about the not_binary_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' isn't a binary operator._

## Descrição

O analisador produz este diagnóstico quando an operator that can only be
used as a unary operator is used as a binary operator.

## Exemplo

O código a seguir produz este diagnóstico porque the operator `~` can
only be used as a unary operator:

```dart
var a = 5 [!~!] 3;
```

## Correções comuns

Replace the operator with the correct binary operator:

```dart
var a = 5 - 3;
```
