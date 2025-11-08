---
ia-translate: true
title: extra_positional_arguments_could_be_named
description: >-
  Detalhes sobre o diagnóstico extra_positional_arguments_could_be_named
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Muitos argumentos posicionais: {0} esperados, mas {1} encontrados._

## Descrição

O analisador produz este diagnóstico quando uma invocação de método ou função
tem mais argumentos posicionais do que o método ou função permite, mas o
método ou função define parâmetros nomeados.

## Exemplo

O código a seguir produz este diagnóstico porque `f` define 2
parâmetros posicionais mas tem um parâmetro nomeado que poderia ser usado para o
terceiro argumento:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2, [!3!]);
}
```

## Correções comuns

Se alguns dos argumentos devem ser valores para parâmetros nomeados, então adicione
os nomes antes dos argumentos:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2, c: 3);
}
```

Caso contrário, remova os argumentos que não correspondem a parâmetros
posicionais:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2);
}
```
