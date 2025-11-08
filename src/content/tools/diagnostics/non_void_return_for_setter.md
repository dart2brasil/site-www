---
ia-translate: true
title: non_void_return_for_setter
description: >-
  Detalhes sobre o diagnóstico non_void_return_for_setter
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de retorno do setter deve ser 'void' ou ausente._

## Description

O analisador produz este diagnóstico quando um setter é definido com um
tipo de retorno diferente de `void`.

## Example

O código a seguir produz este diagnóstico porque o setter `p` tem um
tipo de retorno de `int`:

```dart
class C {
  [!int!] set p(int i) => 0;
}
```

## Common fixes

Altere o tipo de retorno para `void` ou omita o tipo de retorno:

```dart
class C {
  set p(int i) => 0;
}
```
