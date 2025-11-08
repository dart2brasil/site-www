---
title: non_constant_map_element
description: >-
  Details about the non_constant_map_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The elements in a const map literal must be constant._

## Descrição

O analisador produz este diagnóstico quando an `if` element or a spread
element in a constant map isn't a constant element.

## Exemplos

O código a seguir produz este diagnóstico porque it's attempting to
spread a non-constant map:

```dart
var notConst = <int, int>{};
var map = const <int, int>{...[!notConst!]};
```

Similarly, the following code produces this diagnostic because the
condition in the `if` element isn't a constant expression:

```dart
bool notConst = true;
var map = const <int, int>{if ([!notConst!]) 1 : 2};
```

## Correções comuns

If the map needs to be a constant map, then make the elements constants.
In the spread example, you might do that by making the collection being
spread a constant:

```dart
const notConst = <int, int>{};
var map = const <int, int>{...notConst};
```

If the map doesn't need to be a constant map, then remove the `const`
keyword:

```dart
bool notConst = true;
var map = <int, int>{if (notConst) 1 : 2};
```
