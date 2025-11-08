---
ia-translate: true
title: non_type_as_type_argument
description: >-
  Detalhes sobre o diagnóstico non_type_as_type_argument
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não é um tipo, então não pode ser usado como argumento de tipo._

## Description

O analisador produz este diagnóstico quando um identificador que não é um tipo
é usado como argumento de tipo.

## Example

O código a seguir produz este diagnóstico porque `x` é uma variável, não
um tipo:

```dart
var x = 0;
List<[!x!]> xList = [];
```

## Common fixes

Altere o argumento de tipo para ser um tipo:

```dart
var x = 0;
List<int> xList = [];
```
