---
title: extension_type_implements_not_supertype
description: >-
  Details about the extension_type_implements_not_supertype
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' is not a supertype of '{1}', the representation type._

## Descrição

O analisador produz este diagnóstico quando an extension type implements a
type that isn't a supertype of the representation type.

## Exemplo

O código a seguir produz este diagnóstico porque the extension type `A`
implements `String`, but `String` isn't a supertype of the representation
type `int`:

```dart
extension type A(int i) implements [!String!] {}
```

## Correções comuns

If the representation type is correct, then remove or replace the type in
the implements clause:

```dart
extension type A(int i) {}
```

If the representation type isn't correct, then replace it with the correct
type:

```dart
extension type A(String s) implements String {}
```
