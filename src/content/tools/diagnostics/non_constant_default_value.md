---
ia-translate: true
title: non_constant_default_value
description: >-
  Detalhes sobre o diagnóstico non_constant_default_value
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The default value of an optional parameter must be constant._

## Description

O analisador produz este diagnóstico quando um parâmetro opcional, seja
nomeado ou posicional, possui um valor default que não é uma constante
em tempo de compilação.

## Example

O código a seguir produz este diagnóstico:

```dart
var defaultValue = 3;

void f([int value = [!defaultValue!]]) {}
```

## Common fixes

Se o valor default pode ser convertido para uma constante, então converta-o:

```dart
const defaultValue = 3;

void f([int value = defaultValue]) {}
```

Se o valor default precisa mudar ao longo do tempo, então aplique o valor
default dentro da função:

```dart
var defaultValue = 3;

void f([int? value]) {
  value ??= defaultValue;
}
```
