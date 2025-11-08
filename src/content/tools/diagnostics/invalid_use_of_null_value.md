---
title: invalid_use_of_null_value
description: >-
  Details about the invalid_use_of_null_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_An expression whose value is always 'null' can't be dereferenced._

## Descrição

O analisador produz este diagnóstico quando an expression whose value will
always be `null` is dereferenced.

## Exemplo

O código a seguir produz este diagnóstico porque `x` will always be
`null`:

```dart
int f(Null x) {
  return x.[!length!];
}
```

## Correções comuns

If the value is allowed to be something other than `null`, then change the
type of the expression:

```dart
int f(String? x) {
  return x!.length;
}
```
