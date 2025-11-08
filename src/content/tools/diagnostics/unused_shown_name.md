---
ia-translate: true
title: unused_shown_name
description: "Detalhes sobre o diagnóstico unused_shown_name produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome {0} é mostrado, mas não é usado._

## Descrição

O analisador produz este diagnóstico quando um combinador show inclui um
nome que não é usado dentro da biblioteca. Como não é referenciado, o
nome pode ser removido.

## Exemplo

O código a seguir produz este diagnóstico porque a função `max`
não é usada:

```dart
import 'dart:math' show min, [!max!];

var x = min(0, 1);
```

## Correções comuns

Use o nome ou remova-o:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```
