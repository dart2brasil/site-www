---
ia-translate: true
title: unnecessary_cast
description: "Detalhes sobre o diagnóstico unnecessary_cast produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Cast desnecessário._

## Description

O analisador produz este diagnóstico quando o valor que está sendo convertido já é
conhecido por ser do tipo para o qual está sendo convertido.

## Example

O código a seguir produz este diagnóstico porque `n` já é conhecido por
ser um `int` como resultado do teste `is`:

```dart
void f(num n) {
  if (n is int) {
    ([!n as int!]).isEven;
  }
}
```

## Common fixes

Remova o cast desnecessário:

```dart
void f(num n) {
  if (n is int) {
    n.isEven;
  }
}
```
