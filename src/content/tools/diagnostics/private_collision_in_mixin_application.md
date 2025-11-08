---
title: private_collision_in_mixin_application
description: >-
  Details about the private_collision_in_mixin_application
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The private name '{0}', defined by '{1}', conflicts with the same name defined by '{2}'._

## Descrição

O analisador produz este diagnóstico quando two mixins that define the same
private member are used together in a single class in a library other than
the one that defines the mixins.

## Exemplo

Given a file `a.dart` containing the following code:

```dart
mixin A {
  void _foo() {}
}

mixin B {
  void _foo() {}
}
```

O código a seguir produz este diagnóstico porque the mixins `A` and `B`
both define the method `_foo`:

```dart
import 'a.dart';

class C extends Object with A, [!B!] {}
```

## Correções comuns

If you don't need both of the mixins, then remove one of them from the
`with` clause:

```dart
import 'a.dart';

class C extends Object with A, [!B!] {}
```

If you need both of the mixins, then rename the conflicting member in one
of the two mixins.
