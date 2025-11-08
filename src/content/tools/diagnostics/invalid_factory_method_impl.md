---
title: invalid_factory_method_impl
description: >-
  Details about the invalid_factory_method_impl
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Factory method '{0}' doesn't return a newly allocated object._

## Descrição

O analisador produz este diagnóstico quando a method that is annotated with
the [`factory`][meta-factory] annotation doesn't return a newly allocated
object.

## Exemplo

O código a seguir produz este diagnóstico porque the method `createC`
returns the value of a field rather than a newly created instance of `C`:

```dart
import 'package:meta/meta.dart';

class Factory {
  C c = C();

  @factory
  C [!createC!]() => c;
}

class C {}
```

## Correções comuns

Change the method to return a newly created instance of the return type:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  C createC() => C();
}

class C {}
```

[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
