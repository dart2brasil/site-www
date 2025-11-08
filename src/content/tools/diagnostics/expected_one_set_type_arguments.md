---
ia-translate: true
title: expected_one_set_type_arguments
description: "Detalhes sobre o diagnóstico expected_one_set_type_arguments produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Literais de conjunto exigem um argumento de tipo ou nenhum, mas {0} foram encontrados._

## Descrição

O analisador produz este diagnóstico quando um literal de conjunto tem mais de um
argumento de tipo.

## Exemplo

O código a seguir produz este diagnóstico porque o literal de conjunto tem
três argumentos de tipo quando pode ter no máximo um:

```dart
var s = [!<int, String, int>!]{0, 'a', 1};
```

## Correções comuns

Remova todos exceto um dos argumentos de tipo:

```dart
var s = <int>{0, 1};
```
