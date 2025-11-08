---
title: undefined_operator
description: >-
  Details about the undefined_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The operator '{0}' isn't defined for the type '{1}'._

## Descrição

O analisador produz este diagnóstico quando a user-definable operator is
invoked on an object for which the operator isn't defined.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` doesn't
define the operator `+`:

```dart
class C {}

C f(C c) => c [!+!] 2;
```

## Correções comuns

If the operator should be defined for the class, then define it:

```dart
class C {
  C operator +(int i) => this;
}

C f(C c) => c + 2;
```
