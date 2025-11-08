---
ia-translate: true
title: implicit_super_initializer_missing_arguments
description: >-
  Detalhes sobre o diagnóstico implicit_super_initializer_missing_arguments
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor sem nome invocado implicitamente de '{0}' tem parâmetros obrigatórios._

## Descrição

O analisador produz este diagnóstico quando um construtor implicitamente
invoca o construtor sem nome da superclasse, o construtor sem nome
da superclasse tem um parâmetro obrigatório, e não há
parâmetro super correspondente ao parâmetro obrigatório.

## Exemplos

O código a seguir produz este diagnóstico porque o construtor sem nome
na classe `B` implicitamente invoca o construtor sem nome na
classe `A`, mas o construtor em `A` tem um parâmetro posicional
obrigatório chamado `x`:

```dart
class A {
  A(int x);
}

class B extends A {
  [!B!]();
}
```

O código a seguir produz este diagnóstico porque o construtor sem nome
na classe `B` implicitamente invoca o construtor sem nome na
classe `A`, mas o construtor em `A` tem um parâmetro nomeado
obrigatório chamado `x`:

```dart
class A {
  A({required int x});
}

class B extends A {
  [!B!]();
}
```

## Correções comuns

Se você puder adicionar um parâmetro ao construtor na subclasse, então adicione um
parâmetro super correspondente ao parâmetro obrigatório no construtor da superclasse.
O novo parâmetro pode ser obrigatório:

```dart
class A {
  A({required int x});
}

class B extends A {
  B({required super.x});
}
```

ou pode ser opcional:

```dart
class A {
  A({required int x});
}

class B extends A {
  B({super.x = 0});
}
```

Se você não puder adicionar um parâmetro ao construtor na subclasse, então adicione
uma invocação explícita do construtor super com o argumento obrigatório:

```dart
class A {
  A(int x);
}

class B extends A {
  B() : super(0);
}
```
