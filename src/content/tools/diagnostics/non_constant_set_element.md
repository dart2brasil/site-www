---
ia-translate: true
title: non_constant_set_element
description: "Detalhes sobre o diagnóstico non_constant_set_element produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The values in a const set literal must be constants._

## Description

O analisador produz este diagnóstico quando um literal de set constante contém
um elemento que não é uma constante em tempo de compilação.

## Example

O código a seguir produz este diagnóstico porque `i` não é uma constante:

```dart
var i = 0;

var s = const {[!i!]};
```

## Common fixes

Se o elemento pode ser mudado para uma constante, então mude-o:

```dart
const i = 0;

var s = const {i};
```

Se o elemento não pode ser uma constante, então remova a keyword `const`:

```dart
var i = 0;

var s = {i};
```
