---
ia-translate: true
title: wrong_number_of_parameters_for_operator
description: "Detalhes sobre o diagnóstico wrong_number_of_parameters_for_operator produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Operador '-' deve declarar 0 ou 1 parâmetro, mas {0} encontrado._

_Operador '{0}' deve declarar exatamente {1} parâmetros, mas {2} encontrado._

## Descrição

O analisador produz este diagnóstico quando uma declaração de um operador tem
o número errado de parâmetros.

## Exemplo

O código a seguir produz este diagnóstico porque o operador `+` deve
ter um único parâmetro correspondente ao operando direito:

```dart
class C {
  int operator [!+!](a, b) => 0;
}
```

## Correções comuns

Adicione ou remova parâmetros para corresponder ao número necessário:

```dart
class C {
  int operator +(a) => 0;
}
```
