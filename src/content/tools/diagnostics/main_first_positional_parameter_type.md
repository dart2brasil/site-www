---
title: main_first_positional_parameter_type
description: >-
  Detalhes sobre o diagnóstico main_first_positional_parameter_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O tipo do primeiro parameter positional da função 'main' deve ser um supertipo de 'List<String>'._

## Description

O analisador produz este diagnóstico quando o primeiro parameter positional
de uma função chamada `main` não é um supertipo de `List<String>`.

## Example

O código a seguir produz este diagnóstico porque `List<int>` não é um
supertipo de `List<String>`:

```dart
void main([!List<int>!] args) {}
```

## Common fixes

Se a função é um ponto de entrada, então altere o tipo do primeiro
parameter positional para ser um supertipo de `List<String>`:

```dart
void main(List<String> args) {}
```

Se a função não é um ponto de entrada, então altere o nome da função:

```dart
void f(List<int> args) {}
```
