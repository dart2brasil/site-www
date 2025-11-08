---
title: subtype_of_sealed_class
description: >-
  Details about the subtype_of_sealed_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The class '{0}' shouldn't be extended, mixed in, or implemented because it's sealed._

## Descrição

O analisador produz este diagnóstico quando a sealed class (one that either
has the [`sealed`][meta-sealed] annotation or inherits or mixes in a
sealed class) is referenced in either the `extends`, `implements`, or
`with` clause of a class or mixin declaration if the declaration isn't in
the same package as the sealed class.

## Exemplo

Given a library in a package other than the package being analyzed that
contains the following:

```dart
import 'package:meta/meta.dart';

class A {}

@sealed
class B {}
```

O código a seguir produz este diagnóstico porque `C`, which isn't in the
same package as `B`, is extending the sealed class `B`:

```dart
import 'package:a/a.dart';

[!class C extends B {}!]
```

## Correções comuns

If the class doesn't need to be a subtype of the sealed class, then change
the declaration so that it isn't:

```dart
import 'package:a/a.dart';

class B extends A {}
```

If the class needs to be a subtype of the sealed class, then either change
the sealed class so that it's no longer sealed or move the subclass into
the same package as the sealed class.

[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
