---
ia-translate: true
title: disallowed_type_instantiation_expression
description: "Detalhes sobre o diagnóstico disallowed_type_instantiation_expression produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas um tipo genérico, função genérica, método de instância genérico, ou construtor genérico pode ter argumentos de tipo._

## Description

O analisador produz este diagnóstico quando uma expressão com um valor que
é qualquer coisa além de um dos tipos permitidos de valores é seguido por
argumentos de tipo. Os tipos permitidos de valores são:
- tipos genéricos,
- construtores genéricos, e
- funções genéricas, incluindo funções de nível superior, membros static e de instância,
  e funções locais.

## Example

O código a seguir produz este diagnóstico porque `i` é uma variável
de nível superior, que não é um dos casos permitidos:

```dart
int i = 1;

void f() {
  print([!i!]<int>);
}
```

## Common fixes

Se o valor referenciado está correto, então remova os argumentos de tipo:

```dart
int i = 1;

void f() {
  print(i);
}
```
