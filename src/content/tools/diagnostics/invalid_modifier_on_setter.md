---
title: invalid_modifier_on_setter
description: >-
  Details about the invalid_modifier_on_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Setters can't use 'async', 'async*', or 'sync*'._

## Descrição

O analisador produz este diagnóstico quando the body of a setter is prefixed
by one of the following modifiers: `async`, `async*`, or `sync*`. Setter
bodies must be synchronous.

## Exemplo

O código a seguir produz este diagnóstico porque the body of the setter
`x` está marcado como being `async`:

```dart
class C {
  set x(int i) [!async!] {}
}
```

## Correções comuns

If the setter can be synchronous, then remove the modificador:

```dart
class C {
  set x(int i) {}
}
```

If the setter can't be synchronous, then use a method to set the value
instead:

```dart
class C {
  void x(int i) async {}
}
```
