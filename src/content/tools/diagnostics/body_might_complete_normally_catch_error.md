---
title: body_might_complete_normally_catch_error
description: >-
  Detalhes sobre o diagnóstico body_might_complete_normally_catch_error
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Este manipulador 'onError' deve retornar um valor atribuível a '{0}', mas termina sem retornar um valor._

## Description

O analisador produz este diagnóstico quando a closure passada para o
parâmetro `onError` do método `Future.catchError` é obrigada a
retornar um valor não-`null` (por causa do argumento de type do `Future`) mas pode
retornar implicitamente `null`.

## Example

O código a seguir produz este diagnóstico porque a closure passada para
o método `catchError` é obrigada a retornar um `int` mas não termina
com um `return` explícito, fazendo com que ela retorne implicitamente `null`:

```dart
void g(Future<int> f) {
  f.catchError((e, st) [!{!]});
}
```

## Common fixes

Se a closure deve às vezes retornar um valor não-`null`, então adicione um
retorno explícito à closure:

```dart
void g(Future<int> f) {
  f.catchError((e, st) {
    return -1;
  });
}
```

Se a closure deve sempre retornar `null`, então altere o argumento de type
do `Future` para ser `void` ou `Null`:

```dart
void g(Future<void> f) {
  f.catchError((e, st) {});
}
```
