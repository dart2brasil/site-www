---
ia-translate: true
title: invalid_use_of_null_value
description: "Detalhes sobre o diagnóstico invalid_use_of_null_value produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma expressão cujo valor é sempre 'null' não pode ser dereferenciada._

## Description

O analisador produz este diagnóstico quando uma expressão cujo valor sempre
será `null` é dereferenciada.

## Example

O código a seguir produz este diagnóstico porque `x` sempre será
`null`:

```dart
int f(Null x) {
  return x.[!length!];
}
```

## Common fixes

Se o valor pode ser algo diferente de `null`, então altere o
tipo da expressão:

```dart
int f(String? x) {
  return x!.length;
}
```
