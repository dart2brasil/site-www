---
ia-translate: true
title: export_internal_library
description: >-
  Detalhes sobre o diagnóstico export_internal_library
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A library '{0}' é interna e não pode ser exportada._

## Description

O analisador produz este diagnóstico quando encontra um export cujo URI `dart:`
referencia uma library interna.

## Example

O código a seguir produz este diagnóstico porque `_interceptors` é uma
library interna:

```dart
export [!'dart:_interceptors'!];
```

## Common fixes

Remova a diretiva export.
