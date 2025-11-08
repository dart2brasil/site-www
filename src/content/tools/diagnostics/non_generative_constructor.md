---
ia-translate: true
title: non_generative_constructor
description: >-
  Detalhes sobre o diagnóstico non_generative_constructor
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor generativo '{0}' é esperado, mas um factory foi encontrado._

## Description

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor invoca um construtor da superclasse, e o construtor invocado
é um construtor factory. Apenas um construtor generativo pode ser
invocado na lista de inicializadores.

## Example

O código a seguir produz este diagnóstico porque a invocação do
construtor `super.one()` está invocando um construtor factory:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : [!super.one()!];
}
```

## Common fixes

Altere a invocação super para invocar um construtor generativo:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : super.two();
}
```

Se o construtor generativo é o construtor sem nome, e se não há
argumentos sendo passados para ele, então você pode remover a invocação super.
