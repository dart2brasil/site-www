---
title: map_key_type_not_assignable
description: >-
  Detalhes sobre o diagnóstico map_key_type_not_assignable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O tipo do elemento '{0}' não pode ser atribuído ao tipo de chave do map '{1}'._

## Description

O analisador produz este diagnóstico quando uma chave de um par chave-valor em um
literal de map tem um tipo que não é atribuível ao tipo de chave do map.

## Example

O código a seguir produz este diagnóstico porque `2` é um `int`, mas
as chaves do map devem ser `String`s:

```dart
var m = <String, String>{[!2!] : 'a'};
```

## Common fixes

Se o tipo do map está correto, então altere a chave para ter o tipo
correto:

```dart
var m = <String, String>{'2' : 'a'};
```

Se o tipo da chave está correto, então altere o tipo de chave do map:

```dart
var m = <int, String>{2 : 'a'};
```
