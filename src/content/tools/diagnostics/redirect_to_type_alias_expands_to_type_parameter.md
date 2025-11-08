---
ia-translate: true
title: redirect_to_type_alias_expands_to_type_parameter
description: >-
  Detalhes sobre o diagnóstico redirect_to_type_alias_expands_to_type_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um construtor redirecionador não pode redirecionar para um alias de tipo que expande para um parâmetro de tipo._

## Descrição

O analisador produz este diagnóstico quando um factory constructor
redirecionador redireciona para um alias de tipo, e o alias de tipo expande para um dos
parâmetros de tipo do alias de tipo. Isso não é permitido porque o valor
do parâmetro de tipo é um tipo e não uma classe.

## Exemplo

O código a seguir produz este diagnóstico porque o redirecionamento para `B<A>`
é para um alias de tipo cujo valor é `T`, mesmo que pareça que o valor
deveria ser `A`:

```dart
class A implements C {}

typedef B<T> = T;

abstract class C {
  factory C() = [!B!]<A>;
}
```

## Correções comuns

Use um nome de classe ou um alias de tipo que seja definido como uma classe
em vez de um alias de tipo definido como um parâmetro de tipo:

```dart
class A implements C {}

abstract class C {
  factory C() = A;
}
```
