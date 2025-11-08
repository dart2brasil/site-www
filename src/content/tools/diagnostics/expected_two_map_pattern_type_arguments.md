---
ia-translate: true
title: expected_two_map_pattern_type_arguments
description: "Detalhes sobre o diagnóstico expected_two_map_pattern_type_arguments produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Padrões de mapa exigem dois argumentos de tipo ou nenhum, mas {0} foi encontrado._

## Descrição

O analisador produz este diagnóstico quando um padrão de mapa tem um ou
mais de dois argumentos de tipo. Padrões de mapa podem ter dois argumentos
de tipo ou zero argumentos de tipo, mas não podem ter qualquer outro número.

## Exemplo

O código a seguir produz este diagnóstico porque o padrão de mapa
(`<int>{}`) tem um argumento de tipo:

```dart
void f(Object x) {
  if (x case [!<int>!]{0: _}) {}
}
```

## Correções comuns

Adicione ou remova argumentos de tipo até que haja dois ou nenhum:

```dart
void f(Object x) {
  if (x case <int, int>{0: _}) {}
}
```
