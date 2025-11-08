---
title: invalid_literal_annotation
description: >-
  Details about the invalid_literal_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Only const constructors can have the `@literal` annotation._

## Descrição

O analisador produz este diagnóstico quando the [`literal`][meta-literal]
annotation is applied to anything other than a const constructor.

## Exemplos

O código a seguir produz este diagnóstico porque o construtor não é
um construtor `const`:

```dart
import 'package:meta/meta.dart';

class C {
  @[!literal!]
  C();
}
```

O código a seguir produz este diagnóstico porque `x` isn't a
constructor:

```dart
import 'package:meta/meta.dart';

@[!literal!]
var x;
```

## Correções comuns

If the annotation is on a constructor and the constructor should always be
invoked with `const`, when possible, then mark the constructor with the
`const` keyword:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}
```

If the constructor can't be marked as `const`, then remove the annotation.

If the annotation is on anything other than a constructor, then remove the
annotation:

```dart
var x;
```

[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
