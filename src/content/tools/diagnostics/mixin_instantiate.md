---
title: mixin_instantiate
description: >-
  Detalhes sobre o diagnóstico mixin_instantiate
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Mixins não podem ser instanciados._

## Description

O analisador produz este diagnóstico quando um mixin é instanciado.

## Example

O código a seguir produz este diagnóstico porque o mixin `M` está sendo
instanciado:

```dart
mixin M {}

var m = [!M!]();
```

## Common fixes

Se você pretende usar uma instância de uma classe, então use o nome dessa
classe no lugar do nome do mixin.
