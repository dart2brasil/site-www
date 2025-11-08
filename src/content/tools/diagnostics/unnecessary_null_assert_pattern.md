---
ia-translate: true
title: unnecessary_null_assert_pattern
description: >-
  Detalhes sobre o diagnóstico unnecessary_null_assert_pattern
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O padrão null-assert não terá efeito porque o tipo correspondido não é nullable._

## Description

O analisador produz este diagnóstico quando um padrão null-assert é usado
para corresponder a um valor que não é nullable.

## Example

O código a seguir produz este diagnóstico porque a variável `x` não é
nullable:

```dart
void f(int x) {
  if (x case var a[!!!] when a > 0) {}
}
```

## Common fixes

Remova o padrão null-assert:

```dart
void f(int x) {
  if (x case var a when a > 0) {}
}
```
