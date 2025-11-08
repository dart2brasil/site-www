---
title: enum_with_abstract_member
description: >-
  Details about the enum_with_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' must have a method body because '{1}' is an enum._

## Descrição

O analisador produz este diagnóstico quando a member of an enum is found
that doesn't have a concrete implementation. Enums aren't allowed to
contain abstract members.

## Exemplo

O código a seguir produz este diagnóstico porque `m` is an abstract
method and `E` is an enum:

```dart
enum E {
  e;

  [!void m();!]
}
```

## Correções comuns

Provide an implementation for the member:

```dart
enum E {
  e;

  void m() {}
}
```
