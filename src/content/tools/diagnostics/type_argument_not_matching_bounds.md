---
title: type_argument_not_matching_bounds
description: >-
  Details about the type_argument_not_matching_bounds
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' doesn't conform to the bound '{1}' of the type parameter '{2}'._

## Descrição

O analisador produz este diagnóstico quando a type argument isn't the same
as or a subclass of the bounds of the corresponding type parameter.

## Exemplo

O código a seguir produz este diagnóstico porque `String` isn't a
subclass of `num`:

```dart
class A<E extends num> {}

var a = A<[!String!]>();
```

## Correções comuns

Change the type argument to be a subclass of the bounds:

```dart
class A<E extends num> {}

var a = A<int>();
```
