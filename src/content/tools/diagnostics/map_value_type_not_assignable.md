---
title: map_value_type_not_assignable
description: >-
  Detalhes sobre o diagnóstico map_value_type_not_assignable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O tipo do elemento '{0}' não pode ser atribuído ao tipo de valor do map '{1}'._

## Description

O analisador produz este diagnóstico quando um valor de um par chave-valor em um
literal de map tem um tipo que não é atribuível ao tipo de valor do
map.

## Example

O código a seguir produz este diagnóstico porque `2` é um `int`, mas
os valores do map devem ser `String`s:

```dart
var m = <String, String>{'a' : [!2!]};
```

## Common fixes

Se o tipo do map está correto, então altere o valor para ter o
tipo correto:

```dart
var m = <String, String>{'a' : '2'};
```

Se o tipo do valor está correto, então altere o tipo de valor do map:

```dart
var m = <String, int>{'a' : 2};
```
