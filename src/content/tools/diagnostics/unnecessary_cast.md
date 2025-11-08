---
title: unnecessary_cast
description: >-
  Details about the unnecessary_cast
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Unnecessary cast._

## Descrição

O analisador produz este diagnóstico quando the value being cast is already
known to be of the type that it's being cast to.

## Exemplo

O código a seguir produz este diagnóstico porque `n` is already known to
be an `int` as a result of the `is` test:

```dart
void f(num n) {
  if (n is int) {
    ([!n as int!]).isEven;
  }
}
```

## Correções comuns

Remove the unnecessary cast:

```dart
void f(num n) {
  if (n is int) {
    n.isEven;
  }
}
```
