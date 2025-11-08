---
ia-translate: true
title: duplicate_definition
description: "Detalhes sobre o diagnóstico duplicate_definition produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' já está definido._

## Description

O analisador produz este diagnóstico quando um nome é declarado, e há
uma declaração anterior com o mesmo nome no mesmo escopo.

## Example

O código a seguir produz este diagnóstico porque o nome `x` é
declarado duas vezes:

```dart
int x = 0;
int [!x!] = 1;
```

## Common fixes

Escolha um nome diferente para uma das declarações.

```dart
int x = 0;
int y = 1;
```
