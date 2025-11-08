---
title: empty_map_pattern
description: >-
  Details about the empty_map_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A map pattern must have at least one entry._

## Descrição

O analisador produz este diagnóstico quando a map pattern is empty.

## Exemplo

O código a seguir produz este diagnóstico porque the map pattern
is empty:

```dart
void f(Map<int, String> x) {
  if (x case [!{}!]) {}
}
```

## Correções comuns

If the pattern should match any map, then replace it with an object
pattern:

```dart
void f(Map<int, String> x) {
  if (x case Map()) {}
}
```

If the pattern should only match an empty map, then check the length
in the pattern:

```dart
void f(Map<int, String> x) {
  if (x case Map(isEmpty: true)) {}
}
```
