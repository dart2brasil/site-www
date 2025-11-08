---
title: unnecessary_null_check_pattern
description: >-
  Details about the unnecessary_null_check_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The null-check pattern will have no effect because the matched type isn't nullable._

## Descrição

O analisador produz este diagnóstico quando a null-check pattern is used to
match a value that isn't nullable.

## Exemplo

O código a seguir produz este diagnóstico porque the value `x` isn't
nullable:

```dart
void f(int x) {
  if (x case var a[!?!] when a > 0) {}
}
```

## Correções comuns

Remove the null-check pattern:

```dart
void f(int x) {
  if (x case var a when a > 0) {}
}
```
