---
ia-translate: true
title: wrong_number_of_type_arguments_extension
description: >-
  Detalhes sobre o diagnóstico wrong_number_of_type_arguments_extension
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A extension '{0}' é declarada com {1} parâmetros de tipo, mas {2} argumentos de tipo foram fornecidos._

## Descrição

O analisador produz este diagnóstico quando uma extension que tem parâmetros de
tipo é usada e argumentos de tipo são fornecidos, mas o número de argumentos de
tipo não é o mesmo que o número de parâmetros de tipo.

## Exemplo

O código a seguir produz este diagnóstico porque a extension `E` é
declarada com um único parâmetro de tipo (`T`), mas a sobrescrita da extension
tem dois argumentos de tipo:

```dart
extension E<T> on List<T> {
  int get len => length;
}

void f(List<int> p) {
  E[!<int, String>!](p).len;
}
```

## Correções comuns

Mude os argumentos de tipo para que haja o mesmo número de argumentos de
tipo que há parâmetros de tipo:

```dart
extension E<T> on List<T> {
  int get len => length;
}

void f(List<int> p) {
  E<int>(p).len;
}
```
