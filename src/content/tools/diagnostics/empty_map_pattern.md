---
ia-translate: true
title: empty_map_pattern
description: >-
  Detalhes sobre o diagnóstico empty_map_pattern
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um map pattern deve ter pelo menos uma entrada._

## Description

O analisador produz este diagnóstico quando um map pattern está empty.

## Example

O código a seguir produz este diagnóstico porque o map pattern
está empty:

```dart
void f(Map<int, String> x) {
  if (x case [!{}!]) {}
}
```

## Common fixes

Se o pattern deve corresponder a qualquer map, então substitua-o por um object
pattern:

```dart
void f(Map<int, String> x) {
  if (x case Map()) {}
}
```

Se o pattern deve corresponder apenas a um map empty, então verifique o tamanho
no pattern:

```dart
void f(Map<int, String> x) {
  if (x case Map(isEmpty: true)) {}
}
```
