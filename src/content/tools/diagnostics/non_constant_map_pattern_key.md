---
title: non_constant_map_pattern_key
description: >-
  Details about the non_constant_map_pattern_key
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Key expressions in map patterns must be constants._

## Descrição

O analisador produz este diagnóstico quando a key in a map pattern isn't a
constant expression.

## Exemplo

O código a seguir produz este diagnóstico porque the key `A()` isn't a
constant:

```dart
void f(Object x) {
  if (x case {[!A()!]: 0}) {}
}

class A {
  const A();
}
```

## Correções comuns

Use a constant for the key:

```dart
void f(Object x) {
  if (x case {const A(): 0}) {}
}

class A {
  const A();
}
```
