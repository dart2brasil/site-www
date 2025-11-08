---
title: mixin_on_sealed_class
description: >-
  Details about the mixin_on_sealed_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' shouldn't be used as a mixin constraint because it is sealed, and any class mixing in this mixin must have '{0}' as a superclass._

## Descrição

O analisador produz este diagnóstico quando the superclass constraint of a
mixin is a class from a different package that was marked as
[`sealed`][meta-sealed]. Classes that are sealed can't be extended,
implemented, mixed in, or used as a superclass constraint.

## Exemplo

If the package `p` defines a sealed class:

```dart
import 'package:meta/meta.dart';

@sealed
class C {}
```

Then, the following code, when in a package other than `p`, produces this
diagnostic:

```dart
import 'package:p/p.dart';

[!mixin M on C {}!]
```

## Correções comuns

If the classes that use the mixin don't need to be subclasses of the sealed
class, then consider adding a field and delegating to the wrapped instance
of the sealed class.

[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
