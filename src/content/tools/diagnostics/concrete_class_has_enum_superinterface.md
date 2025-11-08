---
ia-translate: true
title: concrete_class_has_enum_superinterface
description: >-
  Detalhes sobre o diagnóstico concrete_class_has_enum_superinterface
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes concretas não podem ter 'Enum' como superinterface._

## Description

O analisador produz este diagnóstico quando uma classe concreta indiretamente tem
a classe `Enum` como superinterface.

## Example

O código a seguir produz este diagnóstico porque a classe concreta `B`
tem `Enum` como superinterface como resultado de implementar `A`:

```dart
abstract class A implements Enum {}

class [!B!] implements A {}
```

## Common fixes

Se a classe implementada não é a classe que você pretende implementar, então
mude-a:

```dart
abstract class A implements Enum {}

class B implements C {}

class C {}
```

Se a classe implementada pode ser alterada para não implementar `Enum`, então faça
isso:

```dart
abstract class A {}

class B implements A {}
```

Se a classe implementada não pode ser alterada para não implementar `Enum`, então
remova-a da cláusula `implements`:

```dart
abstract class A implements Enum {}

class B {}
```
