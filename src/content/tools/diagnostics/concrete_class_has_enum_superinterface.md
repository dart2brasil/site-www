---
title: concrete_class_has_enum_superinterface
description: >-
  Details about the concrete_class_has_enum_superinterface
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Concrete classes can't have 'Enum' as a superinterface._

## Descrição

O analisador produz este diagnóstico quando a concrete class indirectly has
the class `Enum` as a superinterface.

## Exemplo

O código a seguir produz este diagnóstico porque the concrete class `B`
has `Enum` as a superinterface as a result of implementing `A`:

```dart
abstract class A implements Enum {}

class [!B!] implements A {}
```

## Correções comuns

If the implemented class isn't the class you intend to implement, then
change it:

```dart
abstract class A implements Enum {}

class B implements C {}

class C {}
```

If the implemented class can be changed to not implement `Enum`, then do
so:

```dart
abstract class A {}

class B implements A {}
```

If the implemented class can't be changed to not implement `Enum`, then
remove it from the `implements` clause:

```dart
abstract class A implements Enum {}

class B {}
```
