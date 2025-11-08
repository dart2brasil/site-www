---
ia-translate: true
title: non_exhaustive_switch_expression
description: >-
  Detalhes sobre o diagnóstico non_exhaustive_switch_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' não é exaustivamente correspondido pelos casos do switch, pois não corresponde ao padrão '{1}'._

## Description

O analisador produz este diagnóstico quando uma expressão `switch` está
faltando um caso para um ou mais dos possíveis valores que poderiam fluir
através dela.

## Example

O código a seguir produz este diagnóstico porque a expressão switch
não tem um caso para o valor `E.three`:

```dart
enum E { one, two, three }

String f(E e) => [!switch!] (e) {
    E.one => 'one',
    E.two => 'two',
  };
```

## Common fixes

Se os valores faltantes são distintamente significativos para a expressão switch,
então adicione um caso para cada um dos valores que faltam correspondência:

```dart
enum E { one, two, three }

String f(E e) => switch (e) {
    E.one => 'one',
    E.two => 'two',
    E.three => 'three',
  };
```

Se os valores faltantes não precisam ser correspondidos, então adicione um
padrão wildcard que retorna um padrão simples:

```dart
enum E { one, two, three }

String f(E e) => switch (e) {
    E.one => 'one',
    E.two => 'two',
    _ => 'unknown',
  };
```

Esteja ciente de que um padrão wildcard lidará com quaisquer valores adicionados ao tipo
no futuro. Você perderá a capacidade de ter o compilador avisando se
o `switch` precisa ser atualizado para levar em conta os tipos recém-adicionados.
