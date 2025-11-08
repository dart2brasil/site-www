---
title: invalid_type_argument_in_const_literal
description: >-
  Details about the invalid_type_argument_in_const_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Constant list literals can't use a type parameter in a type argument, such as '{0}'._

_Constant map literals can't use a type parameter in a type argument, such as '{0}'._

_Constant set literals can't use a type parameter in a type argument, such as '{0}'._

## Descrição

O analisador produz este diagnóstico quando a type parameter is used in a
type argument in a list, map, or set literal that is prefixed by `const`.
This isn't allowed because the value of the type parameter (the actual type
that will be used at runtime) can't be known at compile time.

## Exemplos

O código a seguir produz este diagnóstico porque the type parameter `T`
is being used as a type argument when creating a constant list:

```dart
List<T> newList<T>() => const <[!T!]>[];
```

O código a seguir produz este diagnóstico porque the type parameter `T`
is being used as a type argument when creating a constant map:

```dart
Map<String, T> newSet<T>() => const <String, [!T!]>{};
```

O código a seguir produz este diagnóstico porque the type parameter `T`
is being used as a type argument when creating a constant set:

```dart
Set<T> newSet<T>() => const <[!T!]>{};
```

## Correções comuns

If the type that will be used for the type parameter can be known at
compile time, then remove the type parameter:

```dart
List<int> newList() => const <int>[];
```

If the type that will be used for the type parameter can't be known until
runtime, then remove the keyword `const`:

```dart
List<T> newList<T>() => <T>[];
```
