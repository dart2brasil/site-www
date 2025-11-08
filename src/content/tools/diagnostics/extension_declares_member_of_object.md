---
title: extension_declares_member_of_object
description: >-
  Details about the extension_declares_member_of_object
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extensions can't declare members with the same name as a member declared by 'Object'._

## Descrição

O analisador produz este diagnóstico quando an extension declaration
declares a member with the same name as a member declared in the class
`Object`. Such a member can never be used because the member in `Object` is
always found first.

## Exemplo

O código a seguir produz este diagnóstico porque `toString` is defined
by `Object`:

```dart
extension E on String {
  String [!toString!]() => this;
}
```

## Correções comuns

Remove the member or rename it so that the name doesn't conflict with the
member in `Object`:

```dart
extension E on String {
  String displayString() => this;
}
```
