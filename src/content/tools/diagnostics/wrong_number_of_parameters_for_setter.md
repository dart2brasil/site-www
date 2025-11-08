---
ia-translate: true
title: wrong_number_of_parameters_for_setter
description: "Detalhes sobre o diagnóstico wrong_number_of_parameters_for_setter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Setters devem declarar exatamente um parâmetro posicional obrigatório._

## Descrição

O analisador produz este diagnóstico quando um setter é encontrado que não
declara exatamente um parâmetro posicional obrigatório.

## Exemplos

O código a seguir produz este diagnóstico porque o setter `s` declara
dois parâmetros obrigatórios:

```dart
class C {
  set [!s!](int x, int y) {}
}
```

O código a seguir produz este diagnóstico porque o setter `s` declara
um parâmetro opcional:

```dart
class C {
  set [!s!]([int? x]) {}
}
```

## Correções comuns

Mude a declaração para que haja exatamente um parâmetro posicional
obrigatório:

```dart
class C {
  set s(int x) {}
}
```
