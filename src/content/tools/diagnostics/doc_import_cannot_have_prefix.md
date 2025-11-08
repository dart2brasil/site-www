---
ia-translate: true
title: doc_import_cannot_have_prefix
description: "Detalhes sobre o diagnóstico doc_import_cannot_have_prefix produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Imports de documentação não podem ter prefixos._

## Descrição

O analisador produz este diagnóstico quando um import de documentação tem um
prefixo.

Usar prefixos não é suportado para imports de documentação.

## Exemplo

O código a seguir produz este diagnóstico porque o import de documentação
declara um prefixo:

```dart
/// @docImport 'package:meta/meta.dart' as [!a!];
library;
```

## Correções comuns

Remova o prefixo:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
