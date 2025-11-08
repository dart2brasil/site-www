---
ia-translate: true
title: import_internal_library
description: >-
  Detalhes sobre o diagnóstico import_internal_library
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca '{0}' é interna e não pode ser importada._

## Description

O analisador produz este diagnóstico quando encontra um import cujo URI
`dart:` referencia uma biblioteca interna.

## Example

O código a seguir produz este diagnóstico porque `_interceptors` é uma
biblioteca interna:

```dart
import [!'dart:_interceptors'!];
```

## Common fixes

Remova a diretiva import.
