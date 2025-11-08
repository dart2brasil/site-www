---
ia-translate: true
title: non_constant_map_key
description: >-
  Detalhes sobre o diagnóstico non_constant_map_key
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The keys in a const map literal must be constant._

## Description

O analisador produz este diagnóstico quando uma chave em um literal de map constante
não é um valor constante.

## Example

O código a seguir produz este diagnóstico porque `a` não é uma constante:

```dart
var a = 'a';
var m = const {[!a!]: 0};
```

## Common fixes

Se o map precisa ser um map constante, então torne a chave uma constante:

```dart
const a = 'a';
var m = const {a: 0};
```

Se o map não precisa ser um map constante, então remova a keyword `const`:

```dart
var a = 'a';
var m = {a: 0};
```
