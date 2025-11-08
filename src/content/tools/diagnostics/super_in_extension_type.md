---
title: super_in_extension_type
description: >-
  Details about the super_in_extension_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The 'super' keyword can't be used in an extension type because an extension type doesn't have a superclass._

## Descrição

O analisador produz este diagnóstico quando `super` is used in an instance
member of an extension type. Extension types don't have superclasses, so
there's no inherited member that could be invoked.

## Exemplo

O código a seguir produz este diagnóstico porque :

```dart
extension type E(String s) {
  void m() {
    [!super!].m();
  }
}
```

## Correções comuns

Replace or remove the `super` invocation:

```dart
extension type E(String s) {
  void m() {
    s.toLowerCase();
  }
}
```
