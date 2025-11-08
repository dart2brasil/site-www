---
ia-translate: true
title: class_used_as_mixin
description: >-
  Detalhes sobre o diagnóstico class_used_as_mixin
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode ser usada como mixin porque não é nem uma mixin class nem um mixin._

## Description

O analisador produz este diagnóstico quando uma classe que não é nem uma
`mixin class` nem um `mixin` é usada em uma cláusula `with`.

## Example

O código a seguir produz este diagnóstico porque a classe `M` está sendo
usada como mixin, mas não está definida como uma `mixin class`:

```dart
class M {}
class C with [!M!] {}
```

## Common fixes

Se a classe pode ser um mixin puro, então mude `class` para `mixin`:

```dart
mixin M {}
class C with M {}
```

Se a classe precisa ser tanto uma classe quanto um mixin, então adicione `mixin`:

```dart
mixin class M {}
class C with M {}
```
