---
title: body_might_complete_normally_nullable
description: >-
  Details about the body_might_complete_normally_nullable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This function has a nullable return type of '{0}', but ends without returning a value._

## Descrição

O analisador produz este diagnóstico quando a method or function can
implicitly return `null` by falling off the end. While this is valid Dart
code, it's better for the return of `null` to be explicit.

## Exemplo

O código a seguir produz este diagnóstico porque the function `f`
implicitly returns `null`:

```dart
String? [!f!]() {}
```

## Correções comuns

If the return of `null` is intentional, then make it explicit:

```dart
String? f() {
  return null;
}
```

If the function should return a non-null value along that path, then add
the missing return statement:

```dart
String? f() {
  return '';
}
```
