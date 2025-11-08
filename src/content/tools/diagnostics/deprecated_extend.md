---
title: deprecated_extend
description: >-
  Details about the deprecated_extend
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extending '{0}' is deprecated._

## Descrição

O analisador produz este diagnóstico quando a class annotated with
`@Deprecated.extend` is used in the `extends` clause of a class
declaration.

This annotation indicates that the ability to extend the annotated class
is deprecated and will soon be removed. This change will likely be
enforced by marking the class with `interface`, `final`, or `sealed`.

## Exemplo

If the library `p` defines a class annotated with `@Deprecated.extend`:

```dart
@Deprecated.extend()
class C {}
```

Then, in any library other than `p`, the following code produces this
diagnostic:

```dart
import 'package:p/p.dart';

class D extends [!C!] {}
```

## Correções comuns

Follow any directions found in the `Deprecation.extend` annotation.
Otherwise, remove the `extends` clause.

```dart
class D {}
```
