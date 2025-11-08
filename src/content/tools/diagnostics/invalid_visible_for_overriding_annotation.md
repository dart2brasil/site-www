---
title: invalid_visible_for_overriding_annotation
description: >-
  Details about the invalid_visible_for_overriding_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation 'visibleForOverriding' can only be applied to a public instance member that can be overridden._

## Descrição

O analisador produz este diagnóstico quando anything other than a public
instance member of a class is annotated with
[`visibleForOverriding`][meta-visibleForOverriding]. Because only public
instance members can be overridden outside the defining library, there's
no value to annotating any other declarations.

## Exemplo

O código a seguir produz este diagnóstico porque the annotation is on a
class, and classes can't be overridden:

```dart
import 'package:meta/meta.dart';

@[!visibleForOverriding!]
class C {}
```

## Correções comuns

Remove the annotation:

```dart
class C {}
```

[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
