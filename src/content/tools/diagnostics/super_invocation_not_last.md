---
ia-translate: true
title: super_invocation_not_last
description: "Detalhes sobre o diagnóstico super_invocation_not_last produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_(Anteriormente conhecido como `invalid_super_invocation`)_

_A chamada do superconstrutor deve ser a última em uma lista de inicializadores: '{0}'._

## Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor contém uma invocação de um construtor na superclasse, mas
a invocação não é o último item na lista de inicializadores.

## Exemplo

O código a seguir produz este diagnóstico porque a invocação do
construtor da superclasse não é o último item na lista de inicializadores:

```dart
class A {
  A(int x);
}

class B extends A {
  B(int x) : [!super!](x), assert(x >= 0);
}
```

## Correções comuns

Mova a invocação do construtor da superclasse para o final da
lista de inicializadores:

```dart
class A {
  A(int x);
}

class B extends A {
  B(int x) : assert(x >= 0), super(x);
}
```
