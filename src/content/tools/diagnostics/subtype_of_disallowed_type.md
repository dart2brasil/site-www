---
ia-translate: true
title: subtype_of_disallowed_type
description: >-
  Detalhes sobre o diagnóstico subtype_of_disallowed_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usado como uma restrição de superclasse._

_Classes e mixins não podem implementar '{0}'._

_Classes não podem estender '{0}'._

_Classes não podem fazer mixin de '{0}'._

## Descrição

O analisador produz este diagnóstico quando uma das classes restritas é
usada em uma cláusula `extends`, `implements`, `with` ou `on`. As
classes `bool`, `double`, `FutureOr`, `int`, `Null`, `num` e `String`
são todas restritas dessa forma, para permitir
implementações mais eficientes.

## Exemplos

O código a seguir produz este diagnóstico porque `String` é usado em uma
cláusula `extends`:

```dart
class A extends [!String!] {}
```

O código a seguir produz este diagnóstico porque `String` é usado em uma
cláusula `implements`:

```dart
class B implements [!String!] {}
```

O código a seguir produz este diagnóstico porque `String` é usado em uma
cláusula `with`:

```dart
class C with [!String!] {}
```

O código a seguir produz este diagnóstico porque `String` é usado em uma
cláusula `on`:

```dart
mixin M on [!String!] {}
```

## Correções comuns

Se um tipo diferente deve ser especificado, então substitua o tipo:

```dart
class A extends Object {}
```

Se não houver um tipo diferente que seja apropriado, então remova o
tipo e, possivelmente, toda a cláusula:

```dart
class B {}
```
