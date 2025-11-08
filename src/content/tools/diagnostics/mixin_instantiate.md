---
title: mixin_instantiate
description: >-
  Details about the mixin_instantiate
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Mixins can't be instantiated._

## Descrição

O analisador produz este diagnóstico quando a mixin is instantiated.

## Exemplo

O código a seguir produz este diagnóstico porque the mixin `M` is being
instantiated:

```dart
mixin M {}

var m = [!M!]();
```

## Correções comuns

If you intend to use an instance of a class, then use the name of that
class in place of the name of the mixin.
