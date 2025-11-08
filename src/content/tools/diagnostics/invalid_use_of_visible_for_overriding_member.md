---
title: invalid_use_of_visible_for_overriding_member
description: >-
  Details about the invalid_use_of_visible_for_overriding_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The member '{0}' can only be used for overriding._

## Descrição

O analisador produz este diagnóstico quando an instance member that is
annotated with [`visibleForOverriding`][meta-visibleForOverriding] is
referenced outside the library in which it's declared for any reason other
than to override it.

## Exemplo

Given a file `a.dart` containing the following declaration:

```dart
import 'package:meta/meta.dart';

class A {
  @visibleForOverriding
  void a() {}
}
```

O código a seguir produz este diagnóstico porque the method `m` is being
invoked even though the only reason it's public is to allow it to be
overridden:

```dart
import 'a.dart';

class B extends A {
  void b() {
    [!a!]();
  }
}
```

## Correções comuns

Remove the invalid use of the member.

[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
