---
ia-translate: true
title: invalid_annotation_target
description: >-
  Detalhes sobre o diagnóstico invalid_annotation_target
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '{0}' só pode ser usada em {1}._

## Description

O analisador produz este diagnóstico quando uma annotation é aplicada a um
tipo de declaração que ela não suporta.

## Example

O código a seguir produz este diagnóstico porque a annotation
`optionalTypeArgs` não está definida para ser válida para variáveis de
nível superior:

```dart
import 'package:meta/meta.dart';

@[!optionalTypeArgs!]
int x = 0;
```

## Common fixes

Remova a annotation da declaração.
