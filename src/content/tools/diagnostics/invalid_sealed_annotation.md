---
ia-translate: true
title: invalid_sealed_annotation
description: "Detalhes sobre o diagnóstico invalid_sealed_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação '@sealed' só pode ser aplicada a classes._

## Description

O analisador produz este diagnóstico quando uma declaração que não seja uma
declaração de classe possui a anotação `@sealed`.

## Example

O código a seguir produz este diagnóstico porque a anotação `@sealed`
está em uma declaração de método:

```dart
import 'package:meta/meta.dart';

class A {
  @[!sealed!]
  void m() {}
}
```

## Common fixes

Remova a anotação:

```dart
class A {
  void m() {}
}
```
