---
ia-translate: true
title: assignment_to_method
description: >-
  Detalhes sobre o diagnóstico assignment_to_method
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Métodos não podem receber um valor._

## Description

O analisador produz este diagnóstico quando o alvo de uma atribuição é um
método.

## Example

O código a seguir produz este diagnóstico porque `f` não pode receber um
valor porque é um método:

```dart
class C {
  void f() {}

  void g() {
    [!f!] = null;
  }
}
```

## Common fixes

Reescreva o código para que não haja uma atribuição a um método.
