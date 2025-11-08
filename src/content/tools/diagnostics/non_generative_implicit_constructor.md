---
ia-translate: true
title: non_generative_implicit_constructor
description: "Detalhes sobre o diagnóstico non_generative_implicit_constructor produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor sem nome da superclasse '{0}' (chamado pelo construtor padrão de '{1}') deve ser um construtor generativo, mas um factory foi encontrado._

## Descrição

O analisador produz este diagnóstico quando uma classe tem um
construtor generativo implícito e a superclasse tem um construtor factory
sem nome explícito. O construtor implícito na subclasse implicitamente invoca
o construtor sem nome na superclasse, mas construtores generativos podem
apenas invocar outro construtor generativo, não um construtor factory.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor implícito
em `B` invoca o construtor sem nome em `A`, mas o
construtor em `A` é um construtor factory, quando um construtor generativo
é obrigatório:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class [!B!] extends A {}
```

## Correções comuns

Se o construtor sem nome na superclasse puder ser um construtor generativo,
então altere-o para ser um construtor generativo:

```dart
class A {
  A();
  A.named();
}

class B extends A { }
```

Se o construtor sem nome não puder ser um construtor generativo e houver
outros construtores generativos na superclasse, então invoque
explicitamente um deles:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class B extends A {
  B() : super.named();
}
```

Se não houver construtores generativos que possam ser usados e nenhum pode ser
adicionado, então implemente a superclasse em vez de estendê-la:

```dart
class A {
  factory A() => throw 0;
  A.named();
}

class B implements A {}
```
