---
ia-translate: true
title: conflicting_type_variable_and_member
description: "Detalhes sobre o diagnóstico conflicting_type_variable_and_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro nesta classe._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro neste enum._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro neste extension type._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro nesta extension._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto um membro neste mixin._

## Descrição

O analisador produz este diagnóstico quando uma declaração de classe, mixin ou extension
declara um parâmetro de tipo com o mesmo nome de um dos
membros da classe, mixin ou extension que o declara.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
tem o mesmo nome do campo `T`:

```dart
class C<[!T!]> {
  int T = 0;
}
```

## Correções comuns

Renomeie o parâmetro de tipo ou o membro com o qual ele conflita:

```dart
class C<T> {
  int total = 0;
}
```
