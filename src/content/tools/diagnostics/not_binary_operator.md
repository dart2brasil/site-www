---
ia-translate: true
title: not_binary_operator
description: >-
  Detalhes sobre o diagnóstico not_binary_operator
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' isn't a binary operator._

## Description

O analisador produz este diagnóstico quando um operador que só pode ser
usado como operador unário é usado como operador binário.

## Example

O código a seguir produz este diagnóstico porque o operador `~` só pode
ser usado como operador unário:

```dart
var a = 5 [!~!] 3;
```

## Common fixes

Substitua o operador pelo operador binário correto:

```dart
var a = 5 - 3;
```
