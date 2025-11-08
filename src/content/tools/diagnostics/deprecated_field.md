---
ia-translate: true
title: deprecated_field
description: >-
  Detalhes sobre o diagnóstico deprecated_field
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O campo '{0}' não é mais usado e pode ser removido._

## Description

O analisador produz este diagnóstico quando uma chave é usada em um
arquivo `pubspec.yaml` que estava deprecated. Chaves não utilizadas ocupam espaço e
podem implicar semânticas que não são mais válidas.

## Example

O código a seguir produz este diagnóstico porque a chave `author` não está
mais sendo usada:

```dart
name: example
author: 'Dash'
```

## Common fixes

Remova a chave deprecated:

```dart
name: example
```
