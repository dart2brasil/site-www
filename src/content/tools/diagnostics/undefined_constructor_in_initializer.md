---
ia-translate: true
title: undefined_constructor_in_initializer
description: >-
  Detalhes sobre o diagnóstico undefined_constructor_in_initializer
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não possui um construtor chamado '{1}'._

_A classe '{0}' não possui um construtor sem nome._

## Descrição

O analisador produz este diagnóstico quando um construtor de superclasse é
invocado na lista de inicializadores de um construtor, mas a superclasse
não define o construtor sendo invocado.

## Exemplos

O código a seguir produz este diagnóstico porque `A` não possui um
construtor sem nome:

```dart
class A {
  A.n();
}
class B extends A {
  B() : [!super()!];
}
```

O código a seguir produz este diagnóstico porque `A` não possui um
construtor chamado `m`:

```dart
class A {
  A.n();
}
class B extends A {
  B() : [!super.m()!];
}
```

## Correções comuns

Se a superclasse define um construtor que deve ser invocado, então altere
o construtor sendo invocado:

```dart
class A {
  A.n();
}
class B extends A {
  B() : super.n();
}
```

Se a superclasse não define um construtor apropriado, então defina
o construtor sendo invocado:

```dart
class A {
  A.m();
  A.n();
}
class B extends A {
  B() : super.m();
}
```
