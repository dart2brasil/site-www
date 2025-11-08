---
title: assignment_to_method
description: >-
  Details about the assignment_to_method
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Methods can't be assigned a value._

## Descrição

O analisador produz este diagnóstico quando the target of an assignment is a
method.

## Exemplo

O código a seguir produz este diagnóstico porque `f` can't be assigned a
value because it's a method:

```dart
class C {
  void f() {}

  void g() {
    [!f!] = null;
  }
}
```

## Correções comuns

Rewrite the code so that there isn't an assignment to a method.
