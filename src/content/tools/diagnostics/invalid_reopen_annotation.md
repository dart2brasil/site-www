---
title: invalid_reopen_annotation
description: >-
  Details about the invalid_reopen_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The annotation '@reopen' can only be applied to a class that opens capabilities that the supertype intentionally disallows._

## Descrição

O analisador produz este diagnóstico quando a `@reopen` annotation has been
placed on a class or mixin that does not remove restrictions placed on the
superclass.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `B` is
annotated with `@reopen` even though it doesn't expand the ability of `A`
to be subclassed:

```dart
import 'package:meta/meta.dart';

sealed class A {}

@[!reopen!]
class B extends A {}
```

## Correções comuns

If the superclass should be restricted in a way that the subclass would
change, then modify the superclass to reflect those restrictions:

```dart
import 'package:meta/meta.dart';

interface class A {}

@reopen
class B extends A {}
```

If the superclass is correct, then remove the annotation:

```dart
sealed class A {}

class B extends A {}
```
