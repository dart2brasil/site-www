---
ia-translate: true
title: invalid_return_type_for_catch_error
description: "Detalhes sobre o diagnóstico invalid_return_type_for_catch_error produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um valor do tipo '{0}' não pode ser retornado pelo handler 'onError' porque deve ser atribuível a '{1}'._

_O tipo de retorno '{0}' não é atribuível a '{1}', como requerido por 'Future.catchError'._

## Description

O analisador produz este diagnóstico quando uma invocação de
`Future.catchError` possui um argumento cujo tipo de retorno não é compatível com
o tipo retornado pela instância de `Future`. Em tempo de execução, o método
`catchError` tenta retornar o valor do callback como resultado
do future, o que resulta em outra exceção sendo lançada.

## Examples

O código a seguir produz este diagnóstico porque `future` é declarado para
retornar um `int` enquanto `callback` é declarado para retornar uma `String`, e
`String` não é um subtipo de `int`:

```dart
void f(Future<int> future, String Function(dynamic, StackTrace) callback) {
  future.catchError([!callback!]);
}
```

O código a seguir produz este diagnóstico porque o closure sendo
passado para `catchError` retorna um `int` enquanto `future` é declarado para
retornar uma `String`:

```dart
void f(Future<String> future) {
  future.catchError((error, stackTrace) => [!3!]);
}
```

## Common fixes

Se a instância de `Future` está declarada corretamente, então altere o callback
para corresponder:

```dart
void f(Future<int> future, int Function(dynamic, StackTrace) callback) {
  future.catchError(callback);
}
```

Se a declaração da instância de `Future` está errada, então altere-a para
corresponder ao callback:

```dart
void f(Future<String> future, String Function(dynamic, StackTrace) callback) {
  future.catchError(callback);
}
```
