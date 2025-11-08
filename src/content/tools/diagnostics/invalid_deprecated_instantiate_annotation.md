---
title: invalid_deprecated_instantiate_annotation
description: >-
  Details about the invalid_deprecated_instantiate_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@Deprecated.instantiate' can only be applied to classes._

## Descrição

O analisador produz este diagnóstico quando the `@Deprecated.instantiate`
annotation is applied to a declaration that isn't an instantiable class.
An instantiable class is one that isn't declared with the `abstract` or
`sealed` keywords and has at least one public, generative constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
sealed class:

```dart
@[!Deprecated.instantiate!]()
sealed class C {}
```

## Correções comuns

Remove the annotation:

```dart
sealed class C {}
```
