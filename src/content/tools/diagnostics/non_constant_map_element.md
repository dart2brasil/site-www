---
ia-translate: true
title: non_constant_map_element
description: >-
  Detalhes sobre o diagnóstico non_constant_map_element
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The elements in a const map literal must be constant._

## Description

O analisador produz este diagnóstico quando um elemento `if` ou um elemento
spread em um map constante não é um elemento constante.

## Examples

O código a seguir produz este diagnóstico porque está tentando
fazer spread de um map não constante:

```dart
var notConst = <int, int>{};
var map = const <int, int>{...[!notConst!]};
```

Similarmente, o código a seguir produz este diagnóstico porque a
condição no elemento `if` não é uma expressão constante:

```dart
bool notConst = true;
var map = const <int, int>{if ([!notConst!]) 1 : 2};
```

## Common fixes

Se o map precisa ser um map constante, então torne os elementos constantes.
No exemplo de spread, você pode fazer isso tornando a coleção sendo
espalhada uma constante:

```dart
const notConst = <int, int>{};
var map = const <int, int>{...notConst};
```

Se o map não precisa ser um map constante, então remova a keyword `const`:

```dart
bool notConst = true;
var map = <int, int>{if (notConst) 1 : 2};
```
