---
title: conflicting_type_variable_and_member
description: >-
  Details about the conflicting_type_variable_and_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' can't be used to name both a type parameter and a member in this class._

_'{0}' can't be used to name both a type parameter and a member in this enum._

_'{0}' can't be used to name both a type parameter and a member in this extension type._

_'{0}' can't be used to name both a type parameter and a member in this extension._

_'{0}' can't be used to name both a type parameter and a member in this mixin._

## Descrição

O analisador produz este diagnóstico quando a class, mixin, or extension
declaration declares a type parameter with the same name as one of the
members of the class, mixin, or extension that declares it.

## Exemplo

O código a seguir produz este diagnóstico porque the type parameter `T`
has the same name as the field `T`:

```dart
class C<[!T!]> {
  int T = 0;
}
```

## Correções comuns

Rename either the type parameter or the member with which it conflicts:

```dart
class C<T> {
  int total = 0;
}
```
