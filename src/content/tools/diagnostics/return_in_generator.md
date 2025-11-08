---
ia-translate: true
title: return_in_generator
description: >-
  Detalhes sobre o diagnóstico return_in_generator
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não é possível retornar um valor de uma função geradora que usa o modificador 'async*' ou 'sync*'._

## Description

O analisador produz este diagnóstico quando uma função geradora (uma cujo
corpo é marcado com `async*` ou `sync*`) usa uma instrução `return`
para retornar um valor ou retorna implicitamente um valor devido ao uso de
`=>`. Em qualquer desses casos, deve-se usar `yield` em vez de `return`.

## Examples

O código a seguir produz este diagnóstico porque o método `f` é um
gerador e está usando `return` para retornar um valor:

```dart
Iterable<int> f() sync* {
  [!return!] 3;
}
```

O código a seguir produz este diagnóstico porque a função `f` é um
gerador e está retornando implicitamente um valor:

```dart
Stream<int> f() async* [!=>!] 3;
```

## Common fixes

Se a função está usando `=>` para o corpo da função, converta-a
para um corpo de função em bloco e use `yield` para retornar um valor:

```dart
Stream<int> f() async* {
  yield 3;
}
```

Se o método é destinado a ser um gerador, use `yield` para retornar um
valor:

```dart
Iterable<int> f() sync* {
  yield 3;
}
```

Se o método não é destinado a ser um gerador, remova o modificador
do corpo (ou use `async` se você está retornando um future):

```dart
int f() {
  return 3;
}
```
