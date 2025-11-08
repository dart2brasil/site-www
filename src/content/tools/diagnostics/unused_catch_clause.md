---
title: unused_catch_clause
description: >-
  Details about the unused_catch_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The exception variable '{0}' isn't used, so the 'catch' clause can be removed._

## Descrição

O analisador produz este diagnóstico quando a `catch` clause is found, and
neither the exception parameter nor the optional stack trace parameter are
used in the `catch` block.

## Exemplo

O código a seguir produz este diagnóstico porque `e` isn't referenced:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException catch ([!e!]) {
    // ignored
  }
}
```

## Correções comuns

Remove the unused `catch` clause:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException {
    // ignored
  }
}
```
