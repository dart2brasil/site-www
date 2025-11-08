---
title: extension_type_implements_itself
description: >-
  Details about the extension_type_implements_itself
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The extension type can't implement itself._

## Descrição

O analisador produz este diagnóstico quando an extension type implements
itself, either directly or indirectly.

## Exemplo

O código a seguir produz este diagnóstico porque the extension type `A`
directly implements itself:

```dart
extension type [!A!](int i) implements A {}
```

O código a seguir produz este diagnóstico porque the extension type `A`
indirectly implements itself (through `B`):

```dart
extension type [!A!](int i) implements B {}

extension type [!B!](int i) implements A {}
```

## Correções comuns

Break the cycle by removing a type from the implements clause of at least
one of the types involved in the cycle:

```dart
extension type A(int i) implements B {}

extension type B(int i) {}
```
