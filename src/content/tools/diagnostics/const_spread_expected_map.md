---
ia-translate: true
title: const_spread_expected_map
description: "Detalhes sobre o diagnóstico const_spread_expected_map produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A map is expected in this spread._

## Descrição

O analisador produz este diagnóstico quando a expressão de um spread
operator em um Map constante é avaliada como algo diferente de um Map.

## Exemplo

O código a seguir produz este diagnóstico porque o valor de `map1` é
`42`, que não é um Map:

```dart
const dynamic map1 = 42;
const Map<String, int> map2 = {...[!map1!]};
```

## Correções comuns

Altere a expressão para algo que seja avaliado como um Map constante:

```dart
const dynamic map1 = {'answer': 42};
const Map<String, int> map2 = {...map1};
```
