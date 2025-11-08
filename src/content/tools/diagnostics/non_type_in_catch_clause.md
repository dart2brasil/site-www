---
title: non_type_in_catch_clause
description: >-
  Details about the non_type_in_catch_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' isn't a type and can't be used in an on-catch clause._

## Descrição

O analisador produz este diagnóstico quando the identifier following the
`on` in a `catch` clause is defined to be something other than a type.

## Exemplo

O código a seguir produz este diagnóstico porque `f` is a function, not
a type:

```dart
void f() {
  try {
    // ...
  } on [!f!] {
    // ...
  }
}
```

## Correções comuns

Change the name to the type of object that should be caught:

```dart
void f() {
  try {
    // ...
  } on FormatException {
    // ...
  }
}
```
