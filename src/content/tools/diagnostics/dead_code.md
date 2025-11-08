---
title: dead_code
description: >-
  Details about the dead_code
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Dead code._

_Dead code: The assigned-to wildcard variable is marked late and can never be referenced so this initializer will never be evaluated._

## Descrição

O analisador produz este diagnóstico quando code is found that won't be
executed because execution will never reach the code.

## Exemplo

O código a seguir produz este diagnóstico porque the invocation of
`print` occurs after the function has returned:

```dart
void f() {
  return;
  [!print('here');!]
}
```

## Correções comuns

If the code isn't needed, then remove it:

```dart
void f() {
  return;
}
```

If the code needs to be executed, then either move the code to a place
where it will be executed:

```dart
void f() {
  print('here');
  return;
}
```

Or, rewrite the code before it, so that it can be reached:

```dart
void f({bool skipPrinting = true}) {
  if (skipPrinting) {
    return;
  }
  print('here');
}
```
