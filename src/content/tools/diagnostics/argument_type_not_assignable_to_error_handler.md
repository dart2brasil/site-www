---
ia-translate: true
title: argument_type_not_assignable_to_error_handler
description: "Detalhes sobre o diagnóstico argument_type_not_assignable_to_error_handler produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The argument type '{0}' can't be assigned to the parameter type '{1} Function(Object)' or '{1} Function(Object, StackTrace)'._

## Description

O analisador produz este diagnóstico quando uma invocação de
`Future.catchError` tem um argument que é uma função cujos parameters
não são compatíveis com os arguments que serão passados para a função
quando ela for invocada. O type estático do primeiro argument para `catchError`
é apenas `Function`, mesmo que a função que é passada seja esperada
ter um único parameter do type `Object` ou dois parameters dos
types `Object` e `StackTrace`.

## Examples

O código a seguir produz este diagnóstico porque o closure sendo
passado para `catchError` não recebe nenhum parameter, mas a função é
obrigada a receber pelo menos um parameter:

```dart
void f(Future<int> f) {
  f.catchError([!() => 0!]);
}
```

O código a seguir produz este diagnóstico porque o closure sendo
passado para `catchError` recebe três parameters, mas não pode ter mais que
dois parameters obrigatórios:

```dart
void f(Future<int> f) {
  f.catchError([!(one, two, three) => 0!]);
}
```

O código a seguir produz este diagnóstico porque mesmo que o closure
sendo passado para `catchError` receba um parameter, o closure não tem
um type que seja compatível com `Object`:

```dart
void f(Future<int> f) {
  f.catchError([!(String error) => 0!]);
}
```

## Common fixes

Altere a função sendo passada para `catchError` para que ela tenha um
ou dois parameters obrigatórios, e os parameters tenham os types esperados:

```dart
void f(Future<int> f) {
  f.catchError((Object error) => 0);
}
```
