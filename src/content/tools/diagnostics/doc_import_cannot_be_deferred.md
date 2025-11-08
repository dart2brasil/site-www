---
ia-translate: true
title: doc_import_cannot_be_deferred
description: "Detalhes sobre o diagnóstico doc_import_cannot_be_deferred produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Imports de documentação não podem ser deferred._

## Descrição

O analisador produz este diagnóstico quando um import de documentação usa a
keyword `deferred`.

Imports de documentação não podem ser deferred porque adiá-los não
impactaria o tamanho do código compilado.

## Exemplo

O código a seguir produz este diagnóstico porque o import de documentação
tem uma keyword `deferred`:

```dart
// ignore:missing_prefix_in_deferred_import
/// @docImport 'package:meta/meta.dart' [!deferred!];
library;
```

## Correções comuns

Remova a keyword `deferred`:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
