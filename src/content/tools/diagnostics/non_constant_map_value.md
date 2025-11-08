---
title: non_constant_map_value
description: >-
  Details about the non_constant_map_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The values in a const map literal must be constant._

## Descrição

O analisador produz este diagnóstico quando a value in a constant map
literal isn't a constant value.

## Exemplo

O código a seguir produz este diagnóstico porque `a` isn't a constant:

```dart
var a = 'a';
var m = const {0: [!a!]};
```

## Correções comuns

If the map needs to be a constant map, then make the key a constant:

```dart
const a = 'a';
var m = const {0: a};
```

If the map doesn't need to be a constant map, then remove the `const`
keyword:

```dart
var a = 'a';
var m = {0: a};
```
