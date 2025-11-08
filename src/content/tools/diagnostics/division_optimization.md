---
ia-translate: true
title: division_optimization
description: "Detalhes sobre o diagnóstico division_optimization produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O operador x ~/ y é mais eficiente que (x / y).toInt()._

## Description

O analisador produz este diagnóstico quando o resultado de dividir dois
números é convertido para um inteiro usando `toInt`. Dart tem um operador
de divisão inteira embutido que é mais eficiente e mais conciso.

## Example

O código a seguir produz este diagnóstico porque o resultado de dividir
`x` e `y` é convertido para um inteiro usando `toInt`:

```dart
int divide(int x, int y) => [!(x / y).toInt()!];
```

## Common fixes

Use o operador de divisão inteira (`~/`):

```dart
int divide(int x, int y) => x ~/ y;
```
