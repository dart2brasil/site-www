---
ia-translate: true
title: illegal_sync_generator_return_type
description: "Detalhes sobre o diagnóstico illegal_sync_generator_return_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Funções marcadas com 'sync*' devem ter um tipo de retorno que seja um supertipo de 'Iterable<T>' para algum tipo 'T'._

## Description

O analisador produz este diagnóstico quando o corpo de uma função tem o
modificador `sync*` mesmo que o tipo de retorno da função não seja
`Iterable` ou um supertipo de `Iterable`.

## Example

O código a seguir produz este diagnóstico porque o corpo da
função `f` tem o modificador 'sync*' mesmo que o tipo de retorno `int`
não seja um supertipo de `Iterable`:

```dart
[!int!] f() sync* {}
```

## Common fixes

Se a função deve retornar um iterable, então altere o tipo de retorno para ser
`Iterable` ou um supertipo de `Iterable`:

```dart
Iterable<int> f() sync* {}
```

Se a função deve retornar um único valor, então remova o modificador `sync*`:

```dart
int f() => 0;
```
