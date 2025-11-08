---
title: mixin_super_class_constraint_deferred_class
description: >-
  Details about the mixin_super_class_constraint_deferred_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Deferred classes can't be used as superclass constraints._

## Descrição

O analisador produz este diagnóstico quando a superclass constraint of a
mixin is imported from a deferred library.

## Exemplo

O código a seguir produz este diagnóstico porque the superclass
constraint of `math.Random` is imported from a deferred library:

```dart
import 'dart:async' deferred as async;

mixin M<T> on [!async.Stream<T>!] {}
```

## Correções comuns

If the import doesn't need to be deferred, then remove the `deferred`
keyword:

```dart
import 'dart:async' as async;

mixin M<T> on async.Stream<T> {}
```

If the import does need to be deferred, then remove the superclass
constraint:

```dart
mixin M<T> {}
```
