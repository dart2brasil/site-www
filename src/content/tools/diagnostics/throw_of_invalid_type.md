---
title: throw_of_invalid_type
description: >-
  Details about the throw_of_invalid_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type '{0}' of the thrown expression must be assignable to 'Object'._

## Descrição

O analisador produz este diagnóstico quando the type of the expression in a
throw expression isn't assignable to `Object`. It isn't valid to throw
`null`, so it isn't valid to use an expression that might evaluate to
`null`.

## Exemplo

O código a seguir produz este diagnóstico porque `s` might be `null`:

```dart
void f(String? s) {
  throw [!s!];
}
```

## Correções comuns

Adicione uma explicit null-check to the expression:

```dart
void f(String? s) {
  throw s!;
}
```
