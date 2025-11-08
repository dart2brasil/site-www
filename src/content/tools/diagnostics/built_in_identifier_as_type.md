---
title: built_in_identifier_as_type
description: >-
  Detalhes sobre o diagnóstico built_in_identifier_as_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O built-in identifier '{0}' não pode ser usado como um type._

## Description

O analisador produz este diagnóstico quando um built-in identifier é usado
onde um nome de type é esperado.

## Example

O código a seguir produz este diagnóstico porque `import` não pode ser usado
como um type porque é um built-in identifier:

```dart
[!import!]<int> x;
```

## Common fixes

Substitua o built-in identifier pelo nome de um type válido:

```dart
List<int> x;
```
