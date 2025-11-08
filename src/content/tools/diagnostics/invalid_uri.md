---
ia-translate: true
title: invalid_uri
description: "Detalhes sobre o diagnóstico invalid_uri produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Sintaxe de URI inválida: '{0}'._

## Description

O analisador produz este diagnóstico quando um URI em uma diretiva não
está em conformidade com a sintaxe de um URI válido.

## Example

O código a seguir produz este diagnóstico porque `'#'` não é um URI
válido:

```dart
import [!'#'!];
```

## Common fixes

Substitua o URI inválido por um URI válido.
