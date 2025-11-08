---
ia-translate: true
title: set_element_type_not_assignable
description: "Detalhes sobre o diagnóstico set_element_type_not_assignable produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo do elemento '{0}' não pode ser atribuído ao tipo do set '{1}'._

## Description

O analisador produz este diagnóstico quando um elemento em um set literal tem
um tipo que não é atribuível ao tipo do elemento do set.

## Example

O código a seguir produz este diagnóstico porque o tipo do string
literal `'0'` é `String`, que não é atribuível a `int`, o tipo do elemento
do set:

```dart
var s = <int>{[!'0'!]};
```

## Common fixes

Se o tipo do elemento do set literal está errado, então altere o tipo do elemento
do set:

```dart
var s = <String>{'0'};
```

Se o tipo do elemento está errado, então altere o elemento:

```dart
var s = <int>{'0'.length};
```
