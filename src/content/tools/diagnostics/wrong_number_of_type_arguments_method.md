---
ia-translate: true
title: wrong_number_of_type_arguments_method
description: "Detalhes sobre o diagnóstico wrong_number_of_type_arguments_method produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O método '{0}' é declarado com {1} parâmetros de tipo, mas {2} argumentos de tipo são fornecidos._

## Descrição

O analisador produz este diagnóstico quando um método ou função é invocado
com um número diferente de argumentos de tipo do que o número de parâmetros de
tipo especificados em sua declaração. Deve haver ou nenhum argumento de
tipo ou o número de argumentos deve corresponder ao número de parâmetros.

## Exemplo

O código a seguir produz este diagnóstico porque a invocação do
método `m` tem dois argumentos de tipo, mas a declaração de `m` tem apenas um
parâmetro de tipo:

```dart
class C {
  int m<A>(A a) => 0;
}

int f(C c) => c.m[!<int, int>!](2);
```

## Correções comuns

Se os argumentos de tipo são necessários, então faça-os corresponder ao número de
parâmetros de tipo adicionando ou removendo argumentos de tipo:

```dart
class C {
  int m<A>(A a) => 0;
}

int f(C c) => c.m<int>(2);
```

Se os argumentos de tipo não são necessários, então remova-os:

```dart
class C {
  int m<A>(A a) => 0;
}

int f(C c) => c.m(2);
```
