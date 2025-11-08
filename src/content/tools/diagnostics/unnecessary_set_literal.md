---
ia-translate: true
title: unnecessary_set_literal
description: >-
  Detalhes sobre o diagnóstico unnecessary_set_literal
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Chaves desnecessariamente envolvem esta expressão em um literal de set._

## Description

O analisador produz este diagnóstico quando uma função que tem um tipo de retorno
de `void`, `Future<void>`, ou `FutureOr<void>` usa um corpo de função de expressão (`=>`) e o valor retornado é um literal de set contendo um
único elemento.

Embora a linguagem permita, retornar um valor de uma função `void`
não é útil porque não pode ser usado no local da chamada. Neste caso particular,
o retorno é frequentemente devido a um mal-entendido sobre a sintaxe. As
chaves não são necessárias e podem ser removidas.

## Example

O código a seguir produz este diagnóstico porque a closure sendo
passada para `g` tem um tipo de retorno de `void`, mas está retornando um set:

```dart
void f() {
  g(() => [!{1}!]);
}

void g(void Function() p) {}
```

## Common fixes

Remova as chaves de ao redor do valor:

```dart
void f() {
  g(() => 1);
}

void g(void Function() p) {}
```
