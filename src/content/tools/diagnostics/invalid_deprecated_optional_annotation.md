---
ia-translate: true
title: invalid_deprecated_optional_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_deprecated_optional_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '@Deprecated.optional' só pode ser aplicada a parâmetros opcionais._

## Description

O analisador produz este diagnóstico quando a annotation
`@Deprecated.optional` é aplicada a um parâmetro que não é um parâmetro
opcional. A annotation não deve ser usada em um parâmetro em uma função
local, uma função anônima, um parâmetro do tipo função ou um typedef. Ela
só é válida em parâmetros opcionais em uma função de nível superior, um
método ou um construtor.

## Example

O código a seguir produz este diagnóstico porque a annotation está em um
parâmetro obrigatório:

```dart
void f(@[!Deprecated.optional!]() int p) {}
```

## Common fixes

Remova a annotation:

```dart
void f(int p) {}
```
