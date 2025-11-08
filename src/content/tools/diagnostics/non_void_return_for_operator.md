---
ia-translate: true
title: non_void_return_for_operator
description: >-
  Detalhes sobre o diagnóstico non_void_return_for_operator
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de retorno do operador []= deve ser 'void'._

## Description

O analisador produz este diagnóstico quando uma declaração do operador
`[]=` tem um tipo de retorno diferente de `void`.

## Example

O código a seguir produz este diagnóstico porque a declaração do
operador `[]=` tem um tipo de retorno de `int`:

```dart
class C {
  [!int!] operator []=(int index, int value) => 0;
}
```

## Common fixes

Altere o tipo de retorno para `void`:

```dart
class C {
  void operator []=(int index, int value) => 0;
}
```
