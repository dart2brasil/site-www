---
title: non_void_return_for_setter
description: >-
  Details about the non_void_return_for_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The return type of the setter must be 'void' or absent._

## Descrição

O analisador produz este diagnóstico quando a setter is defined with a
return type other than `void`.

## Exemplo

O código a seguir produz este diagnóstico porque the setter `p` has a
return type of `int`:

```dart
class C {
  [!int!] set p(int i) => 0;
}
```

## Correções comuns

Change the return type to `void` or omit the return type:

```dart
class C {
  set p(int i) => 0;
}
```
