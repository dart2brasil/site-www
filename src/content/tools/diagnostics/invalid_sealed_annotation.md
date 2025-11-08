---
title: invalid_sealed_annotation
description: >-
  Details about the invalid_sealed_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@sealed' can only be applied to classes._

## Descrição

O analisador produz este diagnóstico quando a declaration other than a
class declaration has the `@sealed` annotation on it.

## Exemplo

O código a seguir produz este diagnóstico porque the `@sealed`
annotation is on a method declaration:

```dart
import 'package:meta/meta.dart';

class A {
  @[!sealed!]
  void m() {}
}
```

## Correções comuns

Remove the annotation:

```dart
class A {
  void m() {}
}
```
