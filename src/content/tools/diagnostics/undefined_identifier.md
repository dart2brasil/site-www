---
title: undefined_identifier
description: >-
  Details about the undefined_identifier
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Undefined name '{0}'._

## Descrição

O analisador produz este diagnóstico quando it encounters an identifier that
either isn't defined or isn't visible in the scope in which it's being
referenced.

## Exemplo

O código a seguir produz este diagnóstico porque the name `rihgt` isn't
defined:

```dart
int min(int left, int right) => left <= [!rihgt!] ? left : right;
```

## Correções comuns

If the identifier isn't defined, then either define it or replace it with
an identifier that is defined. The example above can be corrected by
fixing the spelling of the variable:

```dart
int min(int left, int right) => left <= right ? left : right;
```

If the identifier is defined but isn't visible, then you probably need to
add an import or re-arrange your code to make the identifier visible.
