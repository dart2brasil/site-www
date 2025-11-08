---
ia-translate: true
title: instantiate_type_alias_expands_to_type_parameter
description: >-
  Detalhes sobre o diagnóstico instantiate_type_alias_expands_to_type_parameter
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Type aliases que expandem para um parâmetro de tipo não podem ser instanciados._

## Description

O analisador produz este diagnóstico quando uma invocação de construtor é
encontrada onde o tipo sendo instanciado é um type alias para um dos parâmetros de tipo
do type alias. Isso não é permitido porque o valor do
parâmetro de tipo é um tipo em vez de uma classe.

## Example

O código a seguir produz este diagnóstico porque ele cria uma instância
de `A`, mesmo que `A` seja um type alias que é definido para ser equivalente a
um parâmetro de tipo:

```dart
typedef A<T> = T;

void f() {
  const [!A!]<int>();
}
```

## Common fixes

Use um nome de classe ou um type alias definido para ser uma classe, em vez de
um type alias definido para ser um parâmetro de tipo:

```dart
typedef A<T> = C<T>;

void f() {
  const A<int>();
}

class C<T> {
  const C();
}
```
