---
ia-translate: true
title: private_optional_parameter
description: >-
  Detalhes sobre o diagnóstico private_optional_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros nomeados não podem começar com um underscore._

## Description

O analisador produz este diagnóstico quando o nome de um parâmetro nomeado
começa com um underscore.

## Example

O código a seguir produz este diagnóstico porque o parâmetro nomeado
`_x` começa com um underscore:

```dart
class C {
  void m({int [!_x!] = 0}) {}
}
```

## Common fixes

Renomeie o parâmetro para que não comece com um underscore:

```dart
class C {
  void m({int x = 0}) {}
}
```
