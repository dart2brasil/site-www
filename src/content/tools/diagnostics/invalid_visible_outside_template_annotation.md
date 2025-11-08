---
title: invalid_visible_outside_template_annotation
description: >-
  Details about the invalid_visible_outside_template_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation 'visibleOutsideTemplate' can only be applied to a member of a class, enum, or mixin that is annotated with 'visibleForTemplate'._

## Descrição

O analisador produz este diagnóstico quando the `@visibleOutsideTemplate`
annotation is used incorrectly. This annotation is only meant to annotate
members of a class, enum, or mixin that has the `@visibleForTemplate`
annotation, to opt those members out of the visibility restrictions that
`@visibleForTemplate` imposes.

## Exemplos

O código a seguir produz este diagnóstico porque there is no
`@visibleForTemplate` annotation at the class level:

```dart
import 'package:angular_meta/angular_meta.dart';

class C {
  @[!visibleOutsideTemplate!]
  int m() {
    return 1;
  }
}
```

O código a seguir produz este diagnóstico porque the annotation is on
a class declaration, not a member of a class, enum, or mixin:

```dart
import 'package:angular_meta/angular_meta.dart';

@[!visibleOutsideTemplate!]
class C {}
```

## Correções comuns

If the class is only visible so that templates can reference it, then add
the `@visibleForTemplate` anotação à classe:

```dart
import 'package:angular_meta/angular_meta.dart';

@visibleForTemplate
class C {
  @visibleOutsideTemplate
  int m() {
    return 1;
  }
}
```

If the `@visibleOutsideTemplate` annotation is on anything other than a
member of a class, enum, or mixin with the `@visibleForTemplate`
annotation, remove the annotation:

```dart
class C {}
```
