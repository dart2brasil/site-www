---
ia-translate: true
title: no_generative_constructors_in_superclass
description: >-
  Detalhes sobre o diagnóstico no_generative_constructors_in_superclass
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The class '{0}' can't extend '{1}' because '{1}' only has factory constructors (no generative constructors), and '{0}' has at least one generative constructor._

## Description

O analisador produz este diagnóstico quando uma classe que possui pelo menos um
construtor generativo (explícito ou implícito) tem uma superclasse
que não possui nenhum construtor generativo. Todo construtor generativo,
exceto o definido em `Object`, invoca, explícita
ou implicitamente, um dos construtores generativos de sua
superclasse.

## Example

O código a seguir produz este diagnóstico porque a classe `B` possui um
construtor generativo implícito que não pode invocar um construtor generativo
de `A` porque `A` não possui nenhum construtor generativo:

```dart
class A {
  factory A.none() => throw '';
}

class B extends [!A!] {}
```

## Common fixes

Se a superclasse deveria ter um construtor generativo, então adicione um:

```dart
class A {
  A();
  factory A.none() => throw '';
}

class B extends A {}
```

Se a subclasse não deveria ter um construtor generativo, então remova-o
adicionando um construtor factory:

```dart
class A {
  factory A.none() => throw '';
}

class B extends A {
  factory B.none() => throw '';
}
```

Se a subclasse deve ter um construtor generativo mas a superclasse
não pode ter um, então implemente a superclasse em vez de estendê-la:

```dart
class A {
  factory A.none() => throw '';
}

class B implements A {}
```
