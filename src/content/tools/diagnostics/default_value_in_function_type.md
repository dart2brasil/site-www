---
ia-translate: true
title: default_value_in_function_type
description: >-
  Detalhes sobre o diagnóstico default_value_in_function_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros em um tipo de função não podem ter valores default._

## Description

O analisador produz este diagnóstico quando um tipo de função associado com
um parâmetro inclui parâmetros opcionais que têm um valor default. Isso
não é permitido porque os valores default de parâmetros não fazem parte do
tipo da função, e portanto incluí-los não fornece nenhum valor.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `p` tem um
valor default mesmo sendo parte do tipo do parâmetro `g`:

```dart
void f(void Function([int p [!=!] 0]) g) {
}
```

## Common fixes

Remova o valor default do parâmetro do tipo de função:

```dart
void f(void Function([int p]) g) {
}
```
