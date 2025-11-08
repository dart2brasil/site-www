---
ia-translate: true
title: yield_in_non_generator
description: >-
  Detalhes sobre o diagnóstico yield_in_non_generator
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Declarações yield devem estar em uma função geradora (uma marcada com 'async*' ou 'sync*')._

_Declarações yield-each devem estar em uma função geradora (uma marcada com 'async*' ou 'sync*')._

## Descrição

O analisador produz este diagnóstico quando uma declaração `yield` ou `yield*`
aparece em uma função cujo corpo não está marcado com um dos modificadores `async*` ou
`sync*`.

## Exemplos

O código a seguir produz este diagnóstico porque `yield` está sendo usado
em uma função cujo corpo não tem um modificador:

```dart
Iterable<int> get digits {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

O código a seguir produz este diagnóstico porque `yield*` está sendo usado
em uma função cujo corpo tem o modificador `async` em vez do modificador `async*`:

```dart
Stream<int> get digits async {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

## Correções comuns

Adicione um modificador, ou mude o modificador existente para ser `async*` ou
`sync*`:

```dart
Iterable<int> get digits sync* {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```
