---
title: invalid_deprecated_extend_annotation
description: >-
  Details about the invalid_deprecated_extend_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@Deprecated.extend' can only be applied to extendable classes._

## Descrição

O analisador produz este diagnóstico quando the `@Deprecated.extend`
annotation is applied to a declaration that isn't an extendable class. An
extendable class is one that isn't declared with the `interface`,
`final`, or `sealed` keywords and has at least one public, generative
constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
sealed class:

```dart
@[!Deprecated.extend!]()
sealed class C {}
```

## Correções comuns

Remove the annotation:

```dart
sealed class C {}
```
