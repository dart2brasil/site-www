---
ia-translate: true
title: invocation_of_non_function_expression
description: >-
  Detalhes sobre o diagnóstico invocation_of_non_function_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A expressão não avalia para uma função, então não pode ser invocada._

## Descrição

O analisador produz este diagnóstico quando uma invocação de função é encontrada,
mas o nome sendo referenciado não é o nome de uma função, ou quando a
expressão que computa a função não computa uma função.

## Exemplos

O código a seguir produz este diagnóstico porque `x` não é uma função:

```dart
int x = 0;

int f() => x;

var y = [!x!]();
```

O código a seguir produz este diagnóstico porque `f()` não retorna uma
função:

```dart
int x = 0;

int f() => x;

var y = [!f()!]();
```

## Correções comuns

Se você precisa invocar uma função, então substitua o código antes da lista de argumentos
pelo nome de uma função ou por uma expressão que compute uma
função:

```dart
int x = 0;

int f() => x;

var y = f();
```
