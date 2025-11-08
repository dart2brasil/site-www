---
title: invalid_annotation_target
description: >-
  Details about the invalid_annotation_target
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '{0}' can only be used on {1}._

## Descrição

O analisador produz este diagnóstico quando an annotation is applied to a
kind of declaration that it doesn't support.

## Exemplo

O código a seguir produz este diagnóstico porque the `optionalTypeArgs`
annotation isn't defined to be valid for top-level variables:

```dart
import 'package:meta/meta.dart';

@[!optionalTypeArgs!]
int x = 0;
```

## Correções comuns

Remove the annotation from the declaration.
