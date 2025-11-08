---
ia-translate: true
title: illegal_async_return_type
description: >-
  Detalhes sobre o diagnóstico illegal_async_return_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Funções marcadas com 'async' devem ter um tipo de retorno que seja um supertipo de 'Future'._

## Description

O analisador produz este diagnóstico quando o corpo de uma função tem o
modificador `async` mesmo que o tipo de retorno da função não seja
atribuível a `Future`.

## Example

O código a seguir produz este diagnóstico porque o corpo da
função `f` tem o modificador `async` mesmo que o tipo de retorno não seja
atribuível a `Future`:

```dart
[!int!] f() async {
  return 0;
}
```

## Common fixes

Se a função deve ser assíncrona, então altere o tipo de retorno para ser
atribuível a `Future`:

```dart
Future<int> f() async {
  return 0;
}
```

Se a função deve ser síncrona, então remova o modificador `async`:

```dart
int f() => 0;
```
