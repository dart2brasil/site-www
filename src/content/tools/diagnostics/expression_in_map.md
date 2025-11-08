---
ia-translate: true
title: expression_in_map
description: >-
  Detalhes sobre o diagnóstico expression_in_map
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Expressions não podem ser usadas em um literal de map._

## Description

O analisador produz este diagnóstico quando o analisador encontra uma
expression, ao invés de uma entrada de map, no que parece ser um literal de map.

## Example

O código a seguir produz este diagnóstico:

```dart
var map = <String, int>{'a': 0, 'b': 1, [!'c'!]};
```

## Common fixes

Se a expression deve calcular uma chave ou um valor em uma
entrada, corrija o problema substituindo a expression pela chave ou pelo valor.
Por exemplo:

```dart
var map = <String, int>{'a': 0, 'b': 1, 'c': 2};
```
