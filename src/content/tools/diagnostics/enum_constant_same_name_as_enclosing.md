---
title: enum_constant_same_name_as_enclosing
description: >-
  Details about the enum_constant_same_name_as_enclosing
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name of the enum value can't be the same as the enum's name._

## Descrição

O analisador produz este diagnóstico quando an enum value has the same name
as the enum in which it's declared.

## Exemplo

O código a seguir produz este diagnóstico porque the enum value `E` has
the same name as the enclosing enum `E`:

```dart
enum E {
  [!E!]
}
```

## Correções comuns

If the name of the enum is correct, then rename the constant:

```dart
enum E {
  e
}
```

If the name of the constant is correct, then rename the enum:

```dart
enum F {
  E
}
```
