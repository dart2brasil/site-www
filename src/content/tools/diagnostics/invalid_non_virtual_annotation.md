---
title: invalid_non_virtual_annotation
description: >-
  Details about the invalid_non_virtual_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@nonVirtual' can only be applied to a concrete instance member._

## Descrição

O analisador produz este diagnóstico quando the `nonVirtual` annotation is
found on a declaration other than a member of a class, mixin, or enum, or
if the member isn't a concrete instance member.

## Exemplos

O código a seguir produz este diagnóstico porque the annotation is on a
class declaration rather than a member inside the class:

```dart
import 'package:meta/meta.dart';

@[!nonVirtual!]
class C {}
```

O código a seguir produz este diagnóstico porque the method `m` is an
abstract method:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  void m();
}
```

O código a seguir produz este diagnóstico porque the method `m` is a
static method:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  static void m() {}
}
```

## Correções comuns

If the declaration isn't a member of a class, mixin, or enum, then remove
the annotation:

```dart
class C {}
```

If the member is intended to be a concrete instance member, then make it
so:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @nonVirtual
  void m() {}
}
```

If the member is not intended to be a concrete instance member, then
remove the annotation:

```dart
abstract class C {
  static void m() {}
}
```
