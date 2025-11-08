---
ia-translate: true
title: doc_import_cannot_have_configurations
description: "Detalhes sobre o diagnóstico doc_import_cannot_have_configurations produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Imports de documentação não podem ter configurações._

## Descrição

O analisador produz este diagnóstico quando um import de documentação tem uma
ou mais cláusulas `if`.

Imports de documentação não são configuráveis.

## Exemplo

O código a seguir produz este diagnóstico porque o import de documentação
tem uma cláusula `if`:

```dart
/// @docImport 'package:meta/meta.dart' [!if (dart.library.io) 'dart:io'!];
library;
```

## Correções comuns

Remova as cláusulas `if`:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
