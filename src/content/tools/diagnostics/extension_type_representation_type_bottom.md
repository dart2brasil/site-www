---
title: extension_type_representation_type_bottom
description: >-
  Details about the extension_type_representation_type_bottom
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The representation type can't be a bottom type._

## Descrição

O analisador produz este diagnóstico quando the representation type of an
extension type is the [bottom type][] `Never`. The type `Never` can't be
the representation type of an extension type because there are no values
that can be extended.

## Exemplo

O código a seguir produz este diagnóstico porque the representation
type of the extension type `E` is `Never`:

```dart
extension type E([!Never!] n) {}
```

## Correções comuns

Replace the extension type with a different type:

```dart
extension type E(String s) {}
```

[bottom type]: /null-safety/understanding-null-safety#top-and-bottom
