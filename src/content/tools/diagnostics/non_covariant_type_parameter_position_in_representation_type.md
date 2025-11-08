---
ia-translate: true
title: non_covariant_type_parameter_position_in_representation_type
description: >-
  Detalhes sobre o diagnóstico non_covariant_type_parameter_position_in_representation_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um parâmetro de tipo de extension type não pode ser usado em uma posição não covariante de seu tipo de representação._

## Description

O analisador produz este diagnóstico quando um parâmetro de tipo de um
extension type é usado em uma posição não covariante no tipo de representação
desse extension type.

## Example

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
é usado como tipo de parâmetro no tipo de função `void Function(T)`, e
parâmetros não são covariantes:

```dart
extension type A<[!T!]>(void Function(T) f) {}
```

## Common fixes

Remova o uso do parâmetro de tipo:

```dart
extension type A(void Function(String) f) {}
```
