---
title: invalid_use_of_protected_member
description: >-
  Details about the invalid_use_of_protected_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The member '{0}' can only be used within instance members of subclasses of '{1}'._

## Descrição

O analisador produz este diagnóstico quando a getter, setter, field, or
method that has been annotated with `@protected` is referenced anywhere
other than in the library in which it is declared or in a subclass of the
class in which it is declared.

## Exemplo

Given a file `a.dart` that contains the following:

```dart
import 'package:meta/meta.dart';

class A {
  @protected
  void a() {}
}
```

O código a seguir produz este diagnóstico porque the method `a` is
being invoked in code that isn't in a subclass of `A`:

```dart
import 'a.dart';

void b(A a) {
  a.[!a!]();
}
```

## Correções comuns

If it's reasonable for the member to be marked as `@protected`, then
remove the reference to the protected member, replacing it with some
equivalent code.

If it isn't reasonable for the member to be marked as `@protected`, and
you have the ability to do so, remove the annotation.
