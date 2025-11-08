---
title: variable_type_mismatch
description: >-
  Details about the variable_type_mismatch
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A value of type '{0}' can't be assigned to a const variable of type '{1}'._

## Descrição

O analisador produz este diagnóstico quando the evaluation of a constant
expression would result in a `CastException`.

## Exemplo

O código a seguir produz este diagnóstico porque the value of `x` is an
`int`, which can't be assigned to `y` because an `int` isn't a `String`:

```dart
const dynamic x = 0;
const String y = [!x!];
```

## Correções comuns

If the declaration of the constant is correct, then change the value being
assigned to be of the correct type:

```dart
const dynamic x = 0;
const String y = '$x';
```

If the assigned value is correct, then change the declaration to have the
correct type:

```dart
const int x = 0;
const int y = x;
```
