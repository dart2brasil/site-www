---
title: undefined_setter
description: >-
  Details about the undefined_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The setter '{0}' isn't defined for the '{1}' function type._

_The setter '{0}' isn't defined for the type '{1}'._

## Descrição

O analisador produz este diagnóstico quando it encounters an identifier that
appears to be the name of a setter but either isn't defined or isn't
visible in the scope in which the identifier is being referenced.

## Exemplo

O código a seguir produz este diagnóstico porque there isn't a setter
named `z`:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.[!z!] = y;
  }
}
```

## Correções comuns

If the identifier isn't defined, then either define it or replace it with
the name of a setter that is defined. The example above can be corrected by
fixing the spelling of the setter:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.x = y;
  }
}
```
