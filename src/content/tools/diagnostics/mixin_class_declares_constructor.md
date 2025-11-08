---
title: mixin_class_declares_constructor
description: >-
  Detalhes sobre o diagnóstico mixin_class_declares_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A classe '{0}' não pode ser usada como um mixin porque declara um construtor._

## Description

O analisador produz este diagnóstico quando uma classe é usada como um mixin e
a classe mista define um construtor.

## Example

O código a seguir produz este diagnóstico porque a classe `A`, que
define um construtor, está sendo usada como um mixin:

```dart
//@dart=2.19
class A {
  A();
}

class B with [!A!] {}
```

## Common fixes

Se é possível converter a classe em um mixin, então faça isso:

```dart
mixin A {
}

class B with A {}
```

Se a classe não pode ser um mixin e é possível remover o construtor,
então faça isso:

```dart
//@dart=2.19
class A {
}

class B with A {}
```

Se a classe não pode ser um mixin e você não pode remover o construtor, então
tente estender ou implementar a classe em vez de misturá-la:

```dart
class A {
  A();
}

class B extends A {}
```
