---
title: cast_from_null_always_fails
description: >-
  Details about the cast_from_null_always_fails
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This cast always throws an exception because the expression always evaluates to 'null'._

## Descrição

O analisador produz este diagnóstico quando an expression whose type is
`Null` is being cast to a non-nullable type.

## Exemplo

O código a seguir produz este diagnóstico porque `n` is known to always
be `null`, but it's being cast to a non-nullable type:

```dart
void f(Null n) {
  [!n as int!];
}
```

## Correções comuns

Remove the unnecessary cast:

```dart
void f(Null n) {
  n;
}
```
