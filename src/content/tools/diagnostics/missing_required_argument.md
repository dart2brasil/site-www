---
title: missing_required_argument
description: >-
  Detalhes sobre o diagnóstico missing_required_argument
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O named parameter '{0}' é required, mas não há argumento correspondente._

## Description

O analisador produz este diagnóstico quando uma invocação de uma função está
com um named parameter required missing.

## Example

O código a seguir produz este diagnóstico porque a invocação de `f`
não inclui um valor para o named parameter required `end`:

```dart
void f(int start, {required int end}) {}
void g() {
  [!f!](3);
}
```

## Common fixes

Adicione um argumento named correspondente ao parameter required missing:

```dart
void f(int start, {required int end}) {}
void g() {
  f(3, end: 5);
}
```
