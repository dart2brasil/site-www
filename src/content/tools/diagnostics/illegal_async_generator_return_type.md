---
ia-translate: true
title: illegal_async_generator_return_type
description: "Detalhes sobre o diagnóstico illegal_async_generator_return_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Funções marcadas com 'async*' devem ter um tipo de retorno que seja um supertipo de 'Stream<T>' para algum tipo 'T'._

## Description

O analisador produz este diagnóstico quando o corpo de uma função tem o
modificador `async*` mesmo que o tipo de retorno da função não seja
`Stream` ou um supertipo de `Stream`.

## Example

O código a seguir produz este diagnóstico porque o corpo da
função `f` tem o modificador 'async*' mesmo que o tipo de retorno `int`
não seja um supertipo de `Stream`:

```dart
[!int!] f() async* {}
```

## Common fixes

Se a função deve ser assíncrona, então altere o tipo de retorno para ser
`Stream` ou um supertipo de `Stream`:

```dart
Stream<int> f() async* {}
```

Se a função deve ser síncrona, então remova o modificador `async*`:

```dart
int f() => 0;
```
