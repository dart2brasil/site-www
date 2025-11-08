---
ia-translate: true
title: extra_positional_arguments
description: >-
  Detalhes sobre o diagnóstico extra_positional_arguments
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Muitos argumentos posicionais: {0} esperados, mas {1} encontrados._

## Descrição

O analisador produz este diagnóstico quando uma invocação de método ou função
tem mais argumentos posicionais do que o método ou função permite.

## Exemplo

O código a seguir produz este diagnóstico porque `f` define 2
parâmetros mas é invocada com 3 argumentos:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2, [!3!]);
}
```

## Correções comuns

Remova os argumentos que não correspondem a parâmetros:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2);
}
```
