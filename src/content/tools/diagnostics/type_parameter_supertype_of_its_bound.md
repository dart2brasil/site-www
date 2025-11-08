---
ia-translate: true
title: type_parameter_supertype_of_its_bound
description: >-
  Detalhes sobre o diagnóstico type_parameter_supertype_of_its_bound
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser um supertipo de seu limite superior._

## Descrição

O analisador produz este diagnóstico quando o limite de um parâmetro de tipo
(o tipo após a keyword `extends`) é direta ou indiretamente
o próprio parâmetro de tipo. Afirmar que o parâmetro de tipo deve ser o mesmo
que si mesmo ou um subtipo de si mesmo ou um subtipo de si mesmo não é útil
porque ele sempre será o mesmo que si mesmo.

## Exemplos

O código a seguir produz este diagnóstico porque o limite de `T` é
`T`:

```dart
class C<[!T!] extends T> {}
```

O código a seguir produz este diagnóstico porque o limite de `T1` é
`T2`, e o limite de `T2` é `T1`, efetivamente fazendo o limite de `T1`
ser `T1`:

```dart
class C<[!T1!] extends T2, T2 extends T1> {}
```

## Correções comuns

Se o parâmetro de tipo precisa ser uma subclasse de algum tipo, então substitua o
limite pelo tipo requerido:

```dart
class C<T extends num> {}
```

Se o parâmetro de tipo pode ser qualquer tipo, então remova a cláusula `extends`:

```dart
class C<T> {}
```
