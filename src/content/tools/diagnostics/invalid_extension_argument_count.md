---
ia-translate: true
title: invalid_extension_argument_count
description: >-
  Detalhes sobre o diagnóstico invalid_extension_argument_count
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extension overrides devem ter exatamente um argumento: o valor de 'this' no método extension._

## Description

O analisador produz este diagnóstico quando um extension override não tem
exatamente um argumento. O argumento é a expressão usada para calcular o
valor de `this` dentro do método extension, então deve haver um argumento.

## Examples

O código a seguir produz este diagnóstico porque não há argumentos:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E[!()!].join('b');
}
```

E o código a seguir produz este diagnóstico porque há mais de um argumento:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E[!('a', 'b')!].join('c');
}
```

## Common fixes

Forneça um argumento para o extension override:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E('a').join('b');
}
```
