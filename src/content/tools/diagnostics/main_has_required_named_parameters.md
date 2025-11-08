---
title: main_has_required_named_parameters
description: >-
  Details about the main_has_required_named_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The function 'main' can't have any required named parameters._

## Descrição

O analisador produz este diagnóstico quando a function named `main` has one
or more required named parameters.

## Exemplo

O código a seguir produz este diagnóstico porque the function named
`main` has a required named parameter (`x`):

```dart
void [!main!]({required int x}) {}
```

## Correções comuns

If the function is an entry point, then remove the `required` keyword:

```dart
void main({int? x}) {}
```

If the function isn't an entry point, then change the name of the function:

```dart
void f({required int x}) {}
```
