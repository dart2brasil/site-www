---
ia-translate: true
title: rest_element_in_map_pattern
description: >-
  Detalhes sobre o diagnóstico rest_element_in_map_pattern
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um map pattern não pode conter um rest pattern._

## Description

O analisador produz este diagnóstico quando um map pattern contém um rest
pattern. Map patterns fazem match com um map com mais chaves
do que aquelas explicitamente fornecidas no pattern (desde que as chaves fornecidas façam match),
então um rest pattern é desnecessário.

## Example

O código a seguir produz este diagnóstico porque o map pattern contém
um rest pattern:

```dart
void f(Map<int, String> x) {
  if (x case {0: _, [!...!]}) {}
}
```

## Common fixes

Remova o rest pattern:

```dart
void f(Map<int, String> x) {
  if (x case {0: _}) {}
}
```
