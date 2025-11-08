---
ia-translate: true
title: super_formal_parameter_without_associated_positional
description: >-
  Detalhes sobre o diagnóstico super_formal_parameter_without_associated_positional
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nenhum parâmetro posicional do construtor super associado._

## Descrição

O analisador produz este diagnóstico quando há um parâmetro super
posicional em um construtor e o construtor super invocado implícita ou explicitamente
não possui um parâmetro posicional no índice
correspondente.

Parâmetros super posicionais são associados com parâmetros posicionais no
construtor super por seu índice. Ou seja, o primeiro parâmetro super
é associado ao primeiro parâmetro posicional no construtor
super, o segundo com o segundo, e assim por diante.

## Exemplos

O código a seguir produz este diagnóstico porque o construtor em `B`
possui um parâmetro super posicional, mas não há parâmetro posicional no
construtor super em `A`:

```dart
class A {
  A({int? x});
}

class B extends A {
  B(super.[!x!]);
}
```

O código a seguir produz este diagnóstico porque o construtor em `B`
possui dois parâmetros super posicionais, mas há apenas um parâmetro
posicional no construtor super em `A`, o que significa que não há
parâmetro correspondente para `y`:

```dart
class A {
  A(int x);
}

class B extends A {
  B(super.x, super.[!y!]);
}
```

## Correções comuns

Se o construtor super deve ter um parâmetro posicional correspondente
ao parâmetro super, então atualize o construtor super adequadamente:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(super.x, super.y);
}
```

Se o construtor super está correto, ou não pode ser alterado, então converta o
parâmetro super em um parâmetro normal:

```dart
class A {
  A(int x);
}

class B extends A {
  B(super.x, int y);
}
```
