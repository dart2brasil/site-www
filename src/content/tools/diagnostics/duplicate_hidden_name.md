---
ia-translate: true
title: duplicate_hidden_name
description: >-
  Detalhes sobre o diagnóstico duplicate_hidden_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nome ocultado duplicate._

## Description

O analisador produz este diagnóstico quando um nome ocorre múltiplas vezes em
uma cláusula `hide`. Repetir o nome é desnecessário.

## Example

O código a seguir produz este diagnóstico porque o nome `min` está
oculto mais de uma vez:

```dart
import 'dart:math' hide min, [!min!];

var x = pi;
```

## Common fixes

Se o nome foi digitado incorretamente em um ou mais lugares, então corrija os nomes
digitados incorretamente:

```dart
import 'dart:math' hide max, min;

var x = pi;
```

Se o nome não foi digitado incorretamente, então remova o nome desnecessário da
lista:

```dart
import 'dart:math' hide min;

var x = pi;
```
