---
title: type_alias_cannot_reference_itself
description: >-
  Details about the type_alias_cannot_reference_itself
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Typedefs can't reference themselves directly or recursively via another typedef._

## Descrição

O analisador produz este diagnóstico quando a typedef refers to itself,
either directly or indirectly.

## Exemplo

O código a seguir produz este diagnóstico porque `F` depends on itself
indirectly through `G`:

```dart
typedef [!F!] = void Function(G);
typedef G = void Function(F);
```

## Correções comuns

Change one or more of the typedefs in the cycle so that none of them refer
to themselves:

```dart
typedef F = void Function(G);
typedef G = void Function(int);
```
