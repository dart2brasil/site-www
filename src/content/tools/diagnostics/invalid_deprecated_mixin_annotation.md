---
title: invalid_deprecated_mixin_annotation
description: >-
  Details about the invalid_deprecated_mixin_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@Deprecated.mixin' can only be applied to classes._

## Descrição

O analisador produz este diagnóstico quando the `@Deprecated.mixin`
annotation is applied to a declaration that isn't a mixin class.

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
non-mixin class:

```dart
@[!Deprecated.mixin!]()
class C {}
```

## Correções comuns

Remove the annotation:

```dart
class C {}
```
