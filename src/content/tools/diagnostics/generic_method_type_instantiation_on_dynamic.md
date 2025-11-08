---
ia-translate: true
title: generic_method_type_instantiation_on_dynamic
description: "Detalhes sobre o diagnóstico generic_method_type_instantiation_on_dynamic produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um método tear-off em um receptor cujo tipo é 'dynamic' não pode ter argumentos de tipo._

## Description

O analisador produz este diagnóstico quando um método de instância está sendo separado (torn off)
de um receptor cujo tipo é `dynamic`, e o tear-off inclui argumentos de tipo.
Como o analisador não pode saber quantos parâmetros de tipo o método possui, ou se ele
possui algum parâmetro de tipo, não há como validar se os argumentos de tipo estão
corretos. Como resultado, os argumentos de tipo não são permitidos.

## Example

O código a seguir produz este diagnóstico porque o tipo de `p` é
`dynamic` e o tear-off de `m` tem argumentos de tipo:

```dart
void f(dynamic list) {
  [!list.fold!]<int>;
}
```

## Common fixes

Se você puder usar um tipo mais específico do que `dynamic`, então altere o tipo do
receptor:

```dart
void f(List<Object> list) {
  list.fold<int>;
}
```

Se você não puder usar um tipo mais específico, então remova os argumentos de tipo:

```dart
void f(dynamic list) {
  list.cast;
}
```
