---
ia-translate: true
title: expected_one_list_type_arguments
description: >-
  Detalhes sobre o diagnóstico expected_one_list_type_arguments
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Literais de lista exigem um argumento de tipo ou nenhum, mas {0} foi encontrado._

## Descrição

O analisador produz este diagnóstico quando um literal de lista tem mais de um
argumento de tipo.

## Exemplo

O código a seguir produz este diagnóstico porque o literal de lista tem
dois argumentos de tipo quando pode ter no máximo um:

```dart
var l = [!<int, int>!][];
```

## Correções comuns

Remova todos exceto um dos argumentos de tipo:

```dart
var l = <int>[];
```
