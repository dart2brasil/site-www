---
ia-translate: true
title: unnecessary_wildcard_pattern
description: "Detalhes sobre o diagnóstico unnecessary_wildcard_pattern produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Padrão wildcard desnecessário._

## Description

O analisador produz este diagnóstico quando um padrão wildcard é usado em
um padrão and (`&&`) ou um padrão or (`||`).

## Example

O código a seguir produz este diagnóstico porque o padrão wildcard
(`_`) sempre terá sucesso, tornando seu uso em um padrão and desnecessário:

```dart
void f(Object? x) {
  if (x case [!_!] && 0) {}
}
```

## Common fixes

Remova o uso do padrão wildcard:

```dart
void f(Object? x) {
  if (x case 0) {}
}
```
