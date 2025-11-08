---
ia-translate: true
title: mixin_super_class_constraint_non_interface
description: "Detalhes sobre o diagnóstico mixin_super_class_constraint_non_interface produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas classes e mixins podem ser usados como superclass constraints._

## Description

O analisador produz este diagnóstico quando um tipo após a keyword `on`
em uma declaração de mixin não é nem uma classe nem um mixin.

## Example

O código a seguir produz este diagnóstico porque `F` não é nem uma classe
nem um mixin:

```dart
typedef F = void Function();

mixin M on [!F!] {}
```

## Common fixes

Se o tipo era pretendido ser uma classe mas foi digitado incorretamente, então substitua o
nome.

Caso contrário, remova o tipo da cláusula `on`.
