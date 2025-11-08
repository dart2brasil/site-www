---
title: main_has_required_named_parameters
description: >-
  Detalhes sobre o diagnóstico main_has_required_named_parameters
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A função 'main' não pode ter nenhum named parameter required._

## Description

O analisador produz este diagnóstico quando uma função chamada `main` tem um
ou mais named parameters required.

## Example

O código a seguir produz este diagnóstico porque a função chamada
`main` tem um named parameter required (`x`):

```dart
void [!main!]({required int x}) {}
```

## Common fixes

Se a função é um ponto de entrada, então remova a palavra-chave `required`:

```dart
void main({int? x}) {}
```

Se a função não é um ponto de entrada, então altere o nome da função:

```dart
void f({required int x}) {}
```
