---
ia-translate: true
title: private_setter
description: >-
  Detalhes sobre o diagnóstico private_setter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O setter '{0}' é private e não pode ser acessado fora da biblioteca que o declara._

## Description

O analisador produz este diagnóstico quando um setter private é usado em uma
biblioteca onde ele não está visível.

## Example

Dado um arquivo `a.dart` que contém o seguinte:

```dart
class A {
  static int _f = 0;
}
```

O código a seguir produz este diagnóstico porque referencia o
setter private `_f` mesmo que o setter não esteja visível:

```dart
import 'a.dart';

void f() {
  A.[!_f!] = 0;
}
```

## Common fixes

Se você pode tornar o setter público, faça isso:

```dart
class A {
  static int f = 0;
}
```

Se você não pode tornar o setter público, encontre uma maneira diferente de
implementar o código.
