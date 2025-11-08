---
ia-translate: true
title: invalid_type_argument_in_const_literal
description: >-
  Detalhes sobre o diagnóstico invalid_type_argument_in_const_literal
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Literais de lista constantes não podem usar um parâmetro de tipo em um argumento de tipo, como '{0}'._

_Literais de map constantes não podem usar um parâmetro de tipo em um argumento de tipo, como '{0}'._

_Literais de set constantes não podem usar um parâmetro de tipo em um argumento de tipo, como '{0}'._

## Description

O analisador produz este diagnóstico quando um parâmetro de tipo é usado em um
argumento de tipo em um literal de list, map ou set que é prefixado por `const`.
Isso não é permitido porque o valor do parâmetro de tipo (o tipo real
que será usado em tempo de execução) não pode ser conhecido em tempo de compilação.

## Examples

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
está sendo usado como um argumento de tipo ao criar uma lista constante:

```dart
List<T> newList<T>() => const <[!T!]>[];
```

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
está sendo usado como um argumento de tipo ao criar um map constante:

```dart
Map<String, T> newSet<T>() => const <String, [!T!]>{};
```

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
está sendo usado como um argumento de tipo ao criar um set constante:

```dart
Set<T> newSet<T>() => const <[!T!]>{};
```

## Common fixes

Se o tipo que será usado para o parâmetro de tipo pode ser conhecido em
tempo de compilação, então remova o parâmetro de tipo:

```dart
List<int> newList() => const <int>[];
```

Se o tipo que será usado para o parâmetro de tipo não pode ser conhecido até
o tempo de execução, então remova a keyword `const`:

```dart
List<T> newList<T>() => <T>[];
```
