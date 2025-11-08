---
ia-translate: true
title: non_constant_map_value
description: >-
  Detalhes sobre o diagnóstico non_constant_map_value
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The values in a const map literal must be constant._

## Description

O analisador produz este diagnóstico quando um valor em um literal de map
constante não é um valor constante.

## Example

O código a seguir produz este diagnóstico porque `a` não é uma constante:

```dart
var a = 'a';
var m = const {0: [!a!]};
```

## Common fixes

Se o map precisa ser um map constante, então torne a chave uma constante:

```dart
const a = 'a';
var m = const {0: a};
```

Se o map não precisa ser um map constante, então remova a keyword `const`:

```dart
var a = 'a';
var m = {0: a};
```
