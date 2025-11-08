---
ia-translate: true
title: invocation_of_non_function
description: >-
  Detalhes sobre o diagnóstico invocation_of_non_function
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não é uma função._

## Descrição

O analisador produz este diagnóstico quando encontra uma invocação de função,
mas o nome da função sendo invocada é definido como algo diferente
de uma função.

## Exemplo

O código a seguir produz este diagnóstico porque `Binary` é o nome de
um tipo de função, não uma função:

```dart
typedef Binary = int Function(int, int);

int f() {
  return [!Binary!](1, 2);
}
```

## Correções comuns

Substitua o nome pelo nome de uma função.
