---
title: invalid_modifier_on_constructor
description: >-
  Details about the invalid_modifier_on_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The modifier '{0}' can't be applied to the body of a constructor._

## Descrição

O analisador produz este diagnóstico quando the body of a constructor is
prefixed by one of the following modifiers: `async`, `async*`, or `sync*`.
Constructor bodies must be synchronous.

## Exemplo

O código a seguir produz este diagnóstico porque the body of the
constructor for `C` está marcado como being `async`:

```dart
class C {
  C() [!async!] {}
}
```

## Correções comuns

If the constructor can be synchronous, then remove the modificador:

```dart
class C {
  C();
}
```

If the constructor can't be synchronous, then use a static method to create
the instance instead:

```dart
class C {
  C();
  static Future<C> c() async {
    return C();
  }
}
```
