---
title: illegal_concrete_enum_member
description: >-
  Details about the illegal_concrete_enum_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A concrete instance member named '{0}' can't be declared in a class that implements 'Enum'._

_A concrete instance member named '{0}' can't be inherited from '{1}' in a class that implements 'Enum'._

## Descrição

O analisador produz este diagnóstico quando either an enum declaration, a
class that implements `Enum`, or a mixin with a superclass constraint of
`Enum`, declares or inherits a concrete instance member named either
`index`, `hashCode`, or `==`.

## Exemplos

O código a seguir produz este diagnóstico porque the enum `E` declares
an instance getter named `index`:

```dart
enum E {
  v;

  int get [!index!] => 0;
}
```

O código a seguir produz este diagnóstico porque a classe `C`, which
implements `Enum`, declares an instance field named `hashCode`:

```dart
abstract class C implements Enum {
  int [!hashCode!] = 0;
}
```

O código a seguir produz este diagnóstico porque a classe `C`, which
indirectly implements `Enum` through the class `A`, declares an instance
getter named `hashCode`:

```dart
abstract class A implements Enum {}

abstract class C implements A {
  int get [!hashCode!] => 0;
}
```

O código a seguir produz este diagnóstico porque the mixin `M`, which
has `Enum` in the `on` clause, declares an explicit operator named `==`:

```dart
mixin M on Enum {
  bool operator [!==!](Object other) => false;
}
```

## Correções comuns

Rename the conflicting member:

```dart
enum E {
  v;

  int get getIndex => 0;
}
```
