---
title: mixin_super_class_constraint_deferred_class
description: >-
  Detalhes sobre o diagnóstico mixin_super_class_constraint_deferred_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes deferred não podem ser usadas como constraints de superclasse._

## Description

O analisador produz este diagnóstico quando um constraint de superclasse de um
mixin é importado de uma biblioteca deferred.

## Example

O código a seguir produz este diagnóstico porque o constraint de superclasse
de `math.Random` é importado de uma biblioteca deferred:

```dart
import 'dart:async' deferred as async;

mixin M<T> on [!async.Stream<T>!] {}
```

## Common fixes

Se a importação não precisa ser deferred, então remova a palavra-chave `deferred`:

```dart
import 'dart:async' as async;

mixin M<T> on async.Stream<T> {}
```

Se a importação precisa ser deferred, então remova o constraint de
superclasse:

```dart
mixin M<T> {}
```
