---
title: invalid_annotation_from_deferred_library
description: >-
  Details about the invalid_annotation_from_deferred_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Constant values from a deferred library can't be used as annotations._

## Descrição

O analisador produz este diagnóstico quando a constant from a library that
is imported using a deferred import is used as an annotation. Annotations
are evaluated at compile time, and constants from deferred libraries aren't
available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Exemplo

O código a seguir produz este diagnóstico porque the constant `pi` is
being used as an annotation when the library `dart:math` is imported as
`deferred`:

```dart
import 'dart:math' deferred as math;

@[!math.pi!]
void f() {}
```

## Correções comuns

If you need to reference the constant as an annotation, then remove the
keyword `deferred` from the import:

```dart
import 'dart:math' as math;

@math.pi
void f() {}
```

If you can use a different constant as an annotation, then replace the
annotation with a different constant:

```dart
@deprecated
void f() {}
```
