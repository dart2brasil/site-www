---
title: wrong_number_of_parameters_for_setter
description: >-
  Details about the wrong_number_of_parameters_for_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Setters must declare exactly one required positional parameter._

## Descrição

O analisador produz este diagnóstico quando a setter is found that doesn't
declare exactly one required positional parameter.

## Exemplos

O código a seguir produz este diagnóstico porque the setter `s` declares
two required parameters:

```dart
class C {
  set [!s!](int x, int y) {}
}
```

O código a seguir produz este diagnóstico porque the setter `s` declares
one optional parameter:

```dart
class C {
  set [!s!]([int? x]) {}
}
```

## Correções comuns

Change the declaration so that there's exactly one required positional
parameter:

```dart
class C {
  set s(int x) {}
}
```
