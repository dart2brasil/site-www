---
ia-translate: true
title: type_argument_not_matching_bounds
description: >-
  Detalhes sobre o diagnóstico type_argument_not_matching_bounds
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não está em conformidade com o limite '{1}' do parâmetro de tipo '{2}'._

## Descrição

O analisador produz este diagnóstico quando um argumento de tipo não é o mesmo
que ou uma subclasse dos limites do parâmetro de tipo correspondente.

## Exemplo

O código a seguir produz este diagnóstico porque `String` não é uma
subclasse de `num`:

```dart
class A<E extends num> {}

var a = A<[!String!]>();
```

## Correções comuns

Altere o argumento de tipo para ser uma subclasse dos limites:

```dart
class A<E extends num> {}

var a = A<int>();
```
