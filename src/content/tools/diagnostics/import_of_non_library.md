---
ia-translate: true
title: import_of_non_library
description: "Detalhes sobre o diagnóstico import_of_non_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca importada '{0}' não pode ter uma diretiva part-of._

## Description

O analisador produz este diagnóstico quando um [part file][] é importado
em uma biblioteca.

## Example

Dado um [part file][] chamado `part.dart` contendo o seguinte:

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque arquivos importados não
podem ter uma diretiva part-of:

```dart
library lib;

import [!'part.dart'!];
```

## Common fixes

Importe a biblioteca que contém o [part file][] em vez do próprio
[part file][].

[part file]: /resources/glossary#part-file
