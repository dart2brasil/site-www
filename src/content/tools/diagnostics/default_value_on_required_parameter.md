---
ia-translate: true
title: default_value_on_required_parameter
description: >-
  Detalhes sobre o diagnóstico default_value_on_required_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros nomeados required não podem ter um valor default._

## Description

O analisador produz este diagnóstico quando um parâmetro nomeado tem tanto o
modificador `required` quanto um valor default. Se o parâmetro é obrigatório, então
um valor para o parâmetro é sempre fornecido nos locais de chamada, então o
valor default nunca pode ser usado.

## Example

O código a seguir gera este diagnóstico:

```dart
void log({required String [!message!] = 'no message'}) {}
```

## Common fixes

Se o parâmetro é realmente obrigatório, então remova o valor default:

```dart
void log({required String message}) {}
```

Se o parâmetro não é sempre obrigatório, então remova o modificador `required`:

```dart
void log({String message = 'no message'}) {}
```
