---
ia-translate: true
title: duplicate_import
description: >-
  Detalhes sobre o diagnóstico duplicate_import
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Import duplicate._

## Description

O analisador produz este diagnóstico quando uma diretiva import é encontrada
que é a mesma que um import anterior no arquivo. O segundo import
não adiciona valor e deve ser removido.

## Example

O código a seguir produz este diagnóstico:

```dart
import 'package:meta/meta.dart';
import [!'package:meta/meta.dart'!];

@sealed class C {}
```

## Common fixes

Remova o import desnecessário:

```dart
import 'package:meta/meta.dart';

@sealed class C {}
```
