---
ia-translate: true
title: non_constant_map_pattern_key
description: >-
  Detalhes sobre o diagnóstico non_constant_map_pattern_key
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Key expressions in map patterns must be constants._

## Description

O analisador produz este diagnóstico quando uma chave em um pattern de map não é uma
expressão constante.

## Example

O código a seguir produz este diagnóstico porque a chave `A()` não é uma
constante:

```dart
void f(Object x) {
  if (x case {[!A()!]: 0}) {}
}

class A {
  const A();
}
```

## Common fixes

Use uma constante para a chave:

```dart
void f(Object x) {
  if (x case {const A(): 0}) {}
}

class A {
  const A();
}
```
