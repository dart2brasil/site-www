---
ia-translate: true
title: expected_two_map_type_arguments
description: "Detalhes sobre o diagnóstico expected_two_map_type_arguments produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Literais de mapa exigem dois argumentos de tipo ou nenhum, mas {0} foi encontrado._

## Descrição

O analisador produz este diagnóstico quando um literal de mapa tem um ou
mais de dois argumentos de tipo.

## Exemplo

O código a seguir produz este diagnóstico porque o literal de mapa tem
três argumentos de tipo quando pode ter dois ou nenhum:

```dart
var m = [!<int, String, int>!]{};
```

## Correções comuns

Remova todos exceto dois dos argumentos de tipo:

```dart
var m = <int, String>{};
```
