---
title: const_initialized_with_non_constant_value
description: >-
  Details about the const_initialized_with_non_constant_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Const variables must be initialized with a constant value._

## Descrição

O analisador produz este diagnóstico quando a value that isn't statically
known to be a constant is assigned to a variable that's declared to be a
`const` variable.

## Exemplo

O código a seguir produz este diagnóstico porque `x` isn't declared to
be `const`:

```dart
var x = 0;
const y = [!x!];
```

## Correções comuns

If the value being assigned can be declared to be `const`, then change the
declaration:

```dart
const x = 0;
const y = x;
```

If the value can't be declared to be `const`, then remove the `const`
modifier from the variable, possibly using `final` in its place:

```dart
var x = 0;
final y = x;
```
