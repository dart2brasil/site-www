---
title: values_declaration_in_enum
description: >-
  Details about the values_declaration_in_enum
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A member named 'values' can't be declared in an enum._

## Descrição

O analisador produz este diagnóstico quando an enum declaration defines a
member named `values`, whether the member is an enum value, an instance
member, or a static member.

Any such member conflicts with the implicit declaration of the static
getter named `values` that returns a list containing all the enum
constants.

## Exemplo

O código a seguir produz este diagnóstico porque the enum `E` defines
an instance member named `values`:

```dart
enum E {
  v;
  void [!values!]() {}
}
```

## Correções comuns

Change the name of the conflicting member:

```dart
enum E {
  v;
  void getValues() {}
}
```
