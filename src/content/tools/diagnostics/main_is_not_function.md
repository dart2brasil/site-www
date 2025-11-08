---
title: main_is_not_function
description: "Detalhes sobre o diagnóstico main_is_not_function produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A declaração chamada 'main' deve ser uma função._

## Description

O analisador produz este diagnóstico quando uma biblioteca contém uma declaração
do nome `main` que não é a declaração de uma função de nível superior.

## Example

O código a seguir produz este diagnóstico porque o nome `main` está
sendo usado para declarar uma variável de nível superior:

```dart
var [!main!] = 3;
```

## Common fixes

Use um nome diferente para a declaração:

```dart
var mainIndex = 3;
```
