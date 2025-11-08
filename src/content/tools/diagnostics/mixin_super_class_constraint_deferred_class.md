---
ia-translate: true
title: mixin_super_class_constraint_deferred_class
description: "Detalhes sobre o diagnóstico mixin_super_class_constraint_deferred_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes deferred não podem ser usadas como superclass constraints._

## Description

O analisador produz este diagnóstico quando um superclass constraint de um
mixin é importado de uma biblioteca deferred.

## Example

O código a seguir produz este diagnóstico porque o superclass
constraint de `math.Random` é importado de uma biblioteca deferred:

```dart
import 'dart:async' deferred as async;

mixin M<T> on [!async.Stream<T>!] {}
```

## Common fixes

Se o import não precisa ser deferred, então remova a keyword `deferred`:

```dart
import 'dart:async' as async;

mixin M<T> on async.Stream<T> {}
```

Se o import precisa ser deferred, então remova o superclass
constraint:

```dart
mixin M<T> {}
```
