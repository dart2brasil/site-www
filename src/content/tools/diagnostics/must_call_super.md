---
title: must_call_super
description: >-
  Details about the must_call_super
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This method overrides a method annotated as '@mustCallSuper' in '{0}', but doesn't invoke the overridden method._

## Descrição

O analisador produz este diagnóstico quando a method that overrides a method
that is annotated as [`mustCallSuper`][meta-mustCallSuper] doesn't invoke
the overridden method as required.

## Exemplo

O código a seguir produz este diagnóstico porque the method `m` in `B`
doesn't invoke the overridden method `m` in `A`:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  [!m!]() {}
}
```

## Correções comuns

Adicione uma invocation of the overridden method in the overriding method:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  m() {
    super.m();
  }
}
```

[meta-mustCallSuper]: https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html
