---
ia-translate: true
title: expected_one_list_pattern_type_arguments
description: "Detalhes sobre o diagnóstico expected_one_list_pattern_type_arguments produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Padrões de lista exigem um argumento de tipo ou nenhum, mas {0} foi encontrado._

## Descrição

O analisador produz este diagnóstico quando um padrão de lista tem mais de
um argumento de tipo. Padrões de lista podem ter zero argumentos de tipo ou
um argumento de tipo, mas não podem ter mais de um.

## Exemplo

O código a seguir produz este diagnóstico porque o padrão de lista
(`[0]`) tem dois argumentos de tipo:

```dart
void f(Object x) {
  if (x case [!<int, int>!][0]) {}
}
```

## Correções comuns

Remova todos menos um dos argumentos de tipo:

```dart
void f(Object x) {
  if (x case <int>[0]) {}
}
```
