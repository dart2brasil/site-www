---
ia-translate: true
title: invalid_non_virtual_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_non_virtual_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '@nonVirtual' só pode ser aplicada a um membro de instância concreto._

## Description

O analisador produz este diagnóstico quando a annotation `nonVirtual` é
encontrada em uma declaração que não é um membro de uma classe, mixin ou
enum, ou se o membro não é um membro de instância concreto.

## Examples

O código a seguir produz este diagnóstico porque a annotation está em uma
declaração de classe em vez de um membro dentro da classe:

```dart
import 'package:meta/meta.dart';

@[!nonVirtual!]
class C {}
```

O código a seguir produz este diagnóstico porque o método `m` é um método
abstrato:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  void m();
}
```

O código a seguir produz este diagnóstico porque o método `m` é um método
estático:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  static void m() {}
}
```

## Common fixes

Se a declaração não é um membro de uma classe, mixin ou enum, remova a
annotation:

```dart
class C {}
```

Se o membro é destinado a ser um membro de instância concreto, torne-o
assim:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @nonVirtual
  void m() {}
}
```

Se o membro não é destinado a ser um membro de instância concreto, remova a
annotation:

```dart
abstract class C {
  static void m() {}
}
```
