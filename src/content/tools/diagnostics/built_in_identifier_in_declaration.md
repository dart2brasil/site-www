---
title: built_in_identifier_in_declaration
description: >-
  Details about the built_in_identifier_in_declaration
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The built-in identifier '{0}' can't be used as a prefix name._

_The built-in identifier '{0}' can't be used as a type name._

_The built-in identifier '{0}' can't be used as a type parameter name._

_The built-in identifier '{0}' can't be used as a typedef name._

_The built-in identifier '{0}' can't be used as an extension name._

_The built-in identifier '{0}' can't be used as an extension type name._

## Descrição

O analisador produz este diagnóstico quando the name used in the declaration
of a class, extension, mixin, typedef, type parameter, or import prefix is
a built-in identifier. Built-in identifiers can't be used to name any of
these kinds of declarations.

## Exemplo

O código a seguir produz este diagnóstico porque `mixin` is a built-in
identifier:

```dart
extension [!mixin!] on int {}
```

## Correções comuns

Choose a different name for the declaration.
