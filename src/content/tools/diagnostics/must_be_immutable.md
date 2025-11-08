---
title: must_be_immutable
description: >-
  Details about the must_be_immutable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: {0}_

## Descrição

O analisador produz este diagnóstico quando an immutable class defines one
or more instance fields that aren't final. A class is immutable if it's
marked as being immutable using the annotation
[`immutable`][meta-immutable] or if it's a subclass of an immutable class.

## Exemplo

O código a seguir produz este diagnóstico porque the field `x` isn't
final:

```dart
import 'package:meta/meta.dart';

@immutable
class [!C!] {
  int x;

  C(this.x);
}
```

## Correções comuns

If instances of the class should be immutable, then add the keyword `final`
to all non-final field declarations:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final int x;

  C(this.x);
}
```

If the instances of the class should be mutable, then remove the
annotation, or choose a different superclass if the annotation is
inherited:

```dart
class C {
  int x;

  C(this.x);
}
```

[meta-immutable]: https://pub.dev/documentation/meta/latest/meta/immutable-constant.html
