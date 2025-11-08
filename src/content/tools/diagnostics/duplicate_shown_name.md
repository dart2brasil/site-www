---
ia-translate: true
title: duplicate_shown_name
description: "Detalhes sobre o diagnóstico duplicate_shown_name produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nome exibido duplicate._

## Description

O analisador produz este diagnóstico quando um nome ocorre múltiplas vezes em
uma cláusula `show`. Repetir o nome é desnecessário.

## Example

O código a seguir produz este diagnóstico porque o nome `min` é exibido
mais de uma vez:

```dart
import 'dart:math' show min, [!min!];

var x = min(2, min(0, 1));
```

## Common fixes

Se o nome foi digitado incorretamente em um ou mais lugares, então corrija os nomes
digitados incorretamente:

```dart
import 'dart:math' show max, min;

var x = max(2, min(0, 1));
```

Se o nome não foi digitado incorretamente, então remova o nome desnecessário da
lista:

```dart
import 'dart:math' show min;

var x = min(2, min(0, 1));
```
