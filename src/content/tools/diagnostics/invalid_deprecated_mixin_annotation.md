---
ia-translate: true
title: invalid_deprecated_mixin_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_deprecated_mixin_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '@Deprecated.mixin' só pode ser aplicada a classes._

## Description

O analisador produz este diagnóstico quando a annotation `@Deprecated.mixin`
é aplicada a uma declaração que não é uma classe mixin.

## Example

O código a seguir produz este diagnóstico porque a annotation está em uma
classe que não é mixin:

```dart
@[!Deprecated.mixin!]()
class C {}
```

## Common fixes

Remova a annotation:

```dart
class C {}
```
