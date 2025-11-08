---
title: non_void_return_for_operator
description: >-
  Details about the non_void_return_for_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The return type of the operator []= must be 'void'._

## Descrição

O analisador produz este diagnóstico quando a declaration of the operator
`[]=` has a return type other than `void`.

## Exemplo

O código a seguir produz este diagnóstico porque the declaration of the
operator `[]=` has a return type of `int`:

```dart
class C {
  [!int!] operator []=(int index, int value) => 0;
}
```

## Correções comuns

Change the return type to `void`:

```dart
class C {
  void operator []=(int index, int value) => 0;
}
```
