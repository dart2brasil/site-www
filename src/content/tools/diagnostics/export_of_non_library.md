---
ia-translate: true
title: export_of_non_library
description: >-
  Detalhes sobre o diagnóstico export_of_non_library
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A library exportada '{0}' não pode ter uma diretiva part-of._

## Description

O analisador produz este diagnóstico quando uma diretiva export referencia uma
parte ao invés de uma library.

## Example

Dado um arquivo `part.dart` contendo

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque o arquivo `part.dart` é
uma parte, e apenas libraries podem ser exportadas:

```dart
library lib;

export [!'part.dart'!];
```

## Common fixes

Remova a diretiva export, ou altere o URI para ser o URI da
library que contém a parte.
