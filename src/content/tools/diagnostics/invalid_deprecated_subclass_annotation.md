---
title: invalid_deprecated_subclass_annotation
description: >-
  Details about the invalid_deprecated_subclass_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@Deprecated.subclass' can only be applied to subclassable classes and mixins._

## Descrição

O analisador produz este diagnóstico quando anything other than a
subclassable class or mixin is annotated with
`@Deprecated.subclass`. A subclassable
class is a class not declared with the `final` or `sealed` keywords. A
subclassable mixin is a mixin not declared with the `base` keyword.

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
sealed class:

```dart
@[!Deprecated.subclass!]()
sealed class C {}
```

## Correções comuns

Remove the annotation:

```dart
sealed class C {}
```
