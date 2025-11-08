---
ia-translate: true
title: const_spread_expected_list_or_set
description: >-
  Detalhes sobre o diagnóstico const_spread_expected_list_or_set
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A list or a set is expected in this spread._

## Descrição

O analisador produz este diagnóstico quando a expressão de um spread
operator em uma List ou Set constante é avaliada como algo diferente de uma
List ou um Set.

## Exemplo

O código a seguir produz este diagnóstico porque o valor de `list1` é
`42`, que não é nem uma List nem um Set:

```dart
const dynamic list1 = 42;
const List<int> list2 = [...[!list1!]];
```

## Correções comuns

Altere a expressão para algo que seja avaliado como uma List constante
ou um Set constante:

```dart
const dynamic list1 = [42];
const List<int> list2 = [...list1];
```
