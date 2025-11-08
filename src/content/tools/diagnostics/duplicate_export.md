---
ia-translate: true
title: duplicate_export
description: >-
  Detalhes sobre o diagnóstico duplicate_export
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Export duplicate._

## Description

O analisador produz este diagnóstico quando uma diretiva export é encontrada
que é a mesma que um export anterior no arquivo. O segundo export
não adiciona valor e deve ser removido.

## Example

O código a seguir produz este diagnóstico porque a mesma biblioteca está
sendo exportada duas vezes:

```dart
export 'package:meta/meta.dart';
export [!'package:meta/meta.dart'!];
```

## Common fixes

Remova o export desnecessário:

```dart
export 'package:meta/meta.dart';
```
