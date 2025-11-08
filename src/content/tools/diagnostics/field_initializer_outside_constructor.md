---
title: field_initializer_outside_constructor
description: >-
  Details about the field_initializer_outside_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Field formal parameters can only be used in a constructor._

## Descrição

O analisador produz este diagnóstico quando an initializing formal
parameter is used in the parameter list for anything other than a
constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the initializing
formal parameter `this.x` is being used in the method `m`:

```dart
class A {
  int x = 0;

  m([[!this.x!] = 0]) {}
}
```

## Correções comuns

Replace the initializing formal parameter with a normal parameter and
assign the field within the body of the method:

```dart
class A {
  int x = 0;

  m([int x = 0]) {
    this.x = x;
  }
}
```
