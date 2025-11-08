---
title: super_in_extension
description: >-
  Details about the super_in_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The 'super' keyword can't be used in an extension because an extension doesn't have a superclass._

## Descrição

O analisador produz este diagnóstico quando a member declared inside an
extension uses the `super` keyword . Extensions aren't classes and don't
have superclasses, so the `super` keyword serves no purpose.

## Exemplo

O código a seguir produz este diagnóstico porque `super` can't be used
in an extension:

```dart
extension E on Object {
  String get displayString => [!super!].toString();
}
```

## Correções comuns

Remove the `super` keyword :

```dart
extension E on Object {
  String get displayString => toString();
}
```
