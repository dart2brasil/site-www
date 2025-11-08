---
title: extension_type_implements_disallowed_type
description: >-
  Details about the extension_type_implements_disallowed_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extension types can't implement '{0}'._

## Descrição

O analisador produz este diagnóstico quando an extension type implements a
type that it isn't allowed to implement.

## Exemplo

O código a seguir produz este diagnóstico porque extension types can't
implement the type `dynamic`:

```dart
extension type A(int i) implements [!dynamic!] {}
```

## Correções comuns

Remove the disallowed type from the implements clause:

```dart
extension type A(int i) {}
```
