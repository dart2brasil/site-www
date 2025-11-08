---
title: extra_positional_arguments
description: >-
  Details about the extra_positional_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Too many positional arguments: {0} expected, but {1} found._

## Descrição

O analisador produz este diagnóstico quando a method or function invocation
has more positional arguments than the method or function allows.

## Exemplo

O código a seguir produz este diagnóstico porque `f` defines 2
parameters but is invoked with 3 arguments:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2, [!3!]);
}
```

## Correções comuns

Remove the arguments that don't correspond to parameters:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2);
}
```
