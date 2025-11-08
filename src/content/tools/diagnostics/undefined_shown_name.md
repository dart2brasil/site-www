---
ia-translate: true
title: undefined_shown_name
description: "Detalhes sobre o diagnóstico undefined_shown_name produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca '{0}' não exporta um membro com o nome mostrado '{1}'._

## Descrição

O analisador produz este diagnóstico quando um combinador show inclui um
nome que não está definido pela biblioteca sendo importada.

## Exemplo

O código a seguir produz este diagnóstico porque `dart:math` não
define o nome `String`:

```dart
import 'dart:math' show min, [!String!];

var x = min(0, 1);
```

## Correções comuns

Se um nome diferente deve ser mostrado, então corrija o nome. Caso contrário,
remova o nome da lista:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```
