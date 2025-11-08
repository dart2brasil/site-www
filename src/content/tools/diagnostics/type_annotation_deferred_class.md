---
title: type_annotation_deferred_class
description: >-
  Details about the type_annotation_deferred_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The deferred type '{0}' can't be used in a declaration, cast, or type test._

## Descrição

O analisador produz este diagnóstico quando the type annotation is in a
variable declaration, or the type used in a cast (`as`) or type test (`is`)
is a type declared in a library that is imported using a deferred import.
These types are required to be available at compile time, but aren't.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Exemplo

O código a seguir produz este diagnóstico porque the type of the
parameter `f` is imported from a deferred library:

```dart
import 'dart:io' deferred as io;

void f([!io.File!] f) {}
```

## Correções comuns

If you need to reference the imported type, then remove the `deferred`
keyword:

```dart
import 'dart:io' as io;

void f(io.File f) {}
```

If the import is required to be deferred and there's another type that is
appropriate, then use that type in place of the type from the deferred
library.
