---
title: invalid_deprecated_implement_annotation
description: >-
  Details about the invalid_deprecated_implement_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@Deprecated.implement' can only be applied to implementable classes._

## Descrição

O analisador produz este diagnóstico quando the `@Deprecated.implement`
annotation is applied to a declaration that isn't an implementable class
or mixin. An implementable class or mixin is one that isn't declared with
the base, final, or sealed keywords.

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
sealed class:

```dart
@[!Deprecated.implement!]()
sealed class C {}
```

## Correções comuns

Remove the annotation:

```dart
sealed class C {}
```
