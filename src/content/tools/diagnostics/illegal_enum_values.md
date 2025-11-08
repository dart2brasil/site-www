---
title: illegal_enum_values
description: >-
  Details about the illegal_enum_values
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_An instance member named 'values' can't be declared in a class that implements 'Enum'._

_An instance member named 'values' can't be inherited from '{0}' in a class that implements 'Enum'._

## Descrição

O analisador produz este diagnóstico quando either uma classe que implementa
`Enum` or a mixin with a superclass constraint of `Enum` has an instance
member named `values`.

## Exemplos

O código a seguir produz este diagnóstico porque a classe `C`, which
implements `Enum`, declares an instance field named `values`:

```dart
abstract class C implements Enum {
  int get [!values!] => 0;
}
```

O código a seguir produz este diagnóstico porque a classe `B`, which
implements `Enum`, inherits an instance method named `values` from `A`:

```dart
abstract class A {
  int values() => 0;
}

abstract class [!B!] extends A implements Enum {}
```

## Correções comuns

Change the name of the conflicting member:

```dart
abstract class C implements Enum {
  int get value => 0;
}
```
