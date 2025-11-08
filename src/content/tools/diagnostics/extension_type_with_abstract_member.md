---
title: extension_type_with_abstract_member
description: >-
  Details about the extension_type_with_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' must have a method body because '{1}' is an extension type._

## Descrição

O analisador produz este diagnóstico quando an extension type declares an
abstract member. Because extension type member references are resolved
statically, an abstract member in an extension type could never be
executed.

## Exemplo

O código a seguir produz este diagnóstico porque the method `m` in the
extension type `E` is abstract:

```dart
extension type E(String s) {
  [!void m();!]
}
```

## Correções comuns

If the member is intended to be executable, then provide an implementation
of the member:

```dart
extension type E(String s) {
  void m() {}
}
```

If the member isn't intended to be executable, then remove it:

```dart
extension type E(String s) {}
```
