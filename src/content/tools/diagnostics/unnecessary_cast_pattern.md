---
ia-translate: true
title: unnecessary_cast_pattern
description: "Detalhes sobre o diagnóstico unnecessary_cast_pattern produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Padrão de cast desnecessário._

## Description

O analisador produz este diagnóstico quando um padrão de cast é usado em um
valor que já é conhecido por ser do tipo especificado.

## Example

O código a seguir produz este diagnóstico porque o cast `as num` é
conhecido por sempre ter sucesso porque o tipo de `z` é `int`:

```dart
void f(int x) {
  if (x case var z [!as!] num) {
    print(z);
  }
}
```

## Common fixes

Remova o padrão de cast:

```dart
void f(int x) {
  if (x case var z) {
    print(z);
  }
}
```
