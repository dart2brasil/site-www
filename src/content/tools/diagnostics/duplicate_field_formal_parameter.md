---
title: duplicate_field_formal_parameter
description: >-
  Details about the duplicate_field_formal_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The field '{0}' can't be initialized by multiple parameters in the same constructor._

## Descrição

O analisador produz este diagnóstico quando there's more than one
initializing formal parameter for the same field in a constructor's
parameter list. It isn't useful to assign a value that will immediately be
overwritten.

## Exemplo

O código a seguir produz este diagnóstico porque `this.f` appears twice
in the parameter list:

```dart
class C {
  int f;

  C(this.f, this.[!f!]) {}
}
```

## Correções comuns

Remove one of the initializing formal parameters:

```dart
class C {
  int f;

  C(this.f) {}
}
```
