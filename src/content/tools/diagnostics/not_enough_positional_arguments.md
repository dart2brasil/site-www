---
ia-translate: true
title: not_enough_positional_arguments
description: >-
  Detalhes sobre o diagnóstico not_enough_positional_arguments
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_1 positional argument expected by '{0}', but 0 found._

_1 positional argument expected, but 0 found._

_{0} positional arguments expected by '{1}', but {2} found._

_{0} positional arguments expected, but {1} found._

## Description

O analisador produz este diagnóstico quando uma invocação de método ou função
possui menos argumentos posicionais do que o número de parâmetros posicionais
obrigatórios.

## Example

O código a seguir produz este diagnóstico porque `f` declara dois
parâmetros obrigatórios, mas apenas um argumento é fornecido:

```dart
void f(int a, int b) {}
void g() {
  f(0[!)!];
}
```

## Common fixes

Adicione argumentos correspondentes aos parâmetros restantes:

```dart
void f(int a, int b) {}
void g() {
  f(0, 1);
}
```
