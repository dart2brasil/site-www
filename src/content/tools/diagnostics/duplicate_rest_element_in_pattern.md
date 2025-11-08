---
ia-translate: true
title: duplicate_rest_element_in_pattern
description: >-
  Detalhes sobre o diagnóstico duplicate_rest_element_in_pattern
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_No máximo um elemento rest é permitido em um pattern de lista ou mapa._

## Description

O analisador produz este diagnóstico quando há mais de um pattern rest
em um pattern de lista ou mapa. Um pattern rest capturará quaisquer
valores não correspondidos por outros subpatterns, tornando os patterns rest subsequentes
desnecessários porque não há mais nada para capturar.

## Example

O código a seguir produz este diagnóstico porque há dois patterns
rest no pattern de lista:

```dart
void f(List<int> x) {
  if (x case [0, ..., [!...!]]) {}
}
```

## Common fixes

Remova todos exceto um dos patterns rest:

```dart
void f(List<int> x) {
  if (x case [0, ...]) {}
}
```
