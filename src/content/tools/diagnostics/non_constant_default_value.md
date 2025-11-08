---
title: non_constant_default_value
description: >-
  Details about the non_constant_default_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The default value of an optional parameter must be constant._

## Descrição

O analisador produz este diagnóstico quando an optional parameter, either
named or positional, has a default value that isn't a compile-time
constant.

## Exemplo

The following code produces this diagnostic:

```dart
var defaultValue = 3;

void f([int value = [!defaultValue!]]) {}
```

## Correções comuns

If the default value can be converted to be a constant, then convert it:

```dart
const defaultValue = 3;

void f([int value = defaultValue]) {}
```

If the default value needs to change over time, then apply the default
value inside the function:

```dart
var defaultValue = 3;

void f([int? value]) {
  value ??= defaultValue;
}
```
