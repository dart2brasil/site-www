---
title: non_constant_set_element
description: >-
  Details about the non_constant_set_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The values in a const set literal must be constants._

## Descrição

O analisador produz este diagnóstico quando a constant set literal contains
an element that isn't a compile-time constant.

## Exemplo

O código a seguir produz este diagnóstico porque `i` isn't a constant:

```dart
var i = 0;

var s = const {[!i!]};
```

## Correções comuns

If the element can be changed to be a constant, then change it:

```dart
const i = 0;

var s = const {i};
```

If the element can't be a constant, then remove the keyword `const`:

```dart
var i = 0;

var s = {i};
```
