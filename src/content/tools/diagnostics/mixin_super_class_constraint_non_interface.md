---
title: mixin_super_class_constraint_non_interface
description: >-
  Details about the mixin_super_class_constraint_non_interface
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Only classes and mixins can be used as superclass constraints._

## Descrição

O analisador produz este diagnóstico quando a type following the `on`
keyword in a mixin declaration is neither a class nor a mixin.

## Exemplo

O código a seguir produz este diagnóstico porque `F` is neither a class
nor a mixin:

```dart
typedef F = void Function();

mixin M on [!F!] {}
```

## Correções comuns

If the type was intended to be a class but was mistyped, then replace the
name.

Otherwise, remove the type from the `on` clause.
