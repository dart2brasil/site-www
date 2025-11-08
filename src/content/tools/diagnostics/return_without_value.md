---
ia-translate: true
title: return_without_value
description: >-
  Detalhes sobre o diagnóstico return_without_value
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor de retorno está faltando após 'return'._

## Description

O analisador produz este diagnóstico quando encontra uma instrução `return`
sem uma expressão em uma função que declara um tipo de retorno.

## Example

O código a seguir produz este diagnóstico porque a função `f` é
esperada para retornar um `int`, mas nenhum valor está sendo retornado:

```dart
int f() {
  [!return!];
}
```

## Common fixes

Adicione uma expressão que compute o valor a ser retornado:

```dart
int f() {
  return 0;
}
```
