---
ia-translate: true
title: no_generative_constructors_in_superclass
description: "Detalhes sobre o diagnóstico no_generative_constructors_in_superclass produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode estender '{1}' porque '{1}' tem apenas factory constructors (nenhum generative constructor), e '{0}' tem pelo menos um generative constructor._

## Description

O analisador produz este diagnóstico quando uma classe que tem pelo menos um
generative constructor (seja explícito ou implícito) tem uma superclasse
que não tem nenhum generative constructor. Todo generative
constructor, exceto o definido em `Object`, invoca, seja
explícita ou implicitamente, um dos generative constructors de sua
superclasse.

## Example

O código a seguir produz este diagnóstico porque a classe `B` tem um
generative constructor implícito que não pode invocar um generative constructor
de `A` porque `A` não tem nenhum generative constructor:

```dart
class A {
  factory A.none() => throw '';
}

class B extends [!A!] {}
```

## Common fixes

Se a superclasse deve ter um generative constructor, então adicione um:

```dart
class A {
  A();
  factory A.none() => throw '';
}

class B extends A {}
```

Se a subclasse não deve ter um generative constructor, então remova-o adicionando
um factory constructor:

```dart
class A {
  factory A.none() => throw '';
}

class B extends A {
  factory B.none() => throw '';
}
```

Se a subclasse deve ter um generative constructor mas a superclasse
não pode ter um, então implemente a superclasse em vez disso:

```dart
class A {
  factory A.none() => throw '';
}

class B implements A {}
```
