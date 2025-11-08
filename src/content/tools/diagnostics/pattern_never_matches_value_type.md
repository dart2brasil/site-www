---
title: pattern_never_matches_value_type
description: >-
  Details about the pattern_never_matches_value_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The matched value type '{0}' can never match the required type '{1}'._

## Descrição

O analisador produz este diagnóstico quando the object's type can't be
matched by the pattern.

## Exemplo

O código a seguir produz este diagnóstico porque a `double` is matched
by an `int` pattern, which can never succeed:

```dart
void f(String? s) {
  if (s case [!int!] _) {}
}
```

## Correções comuns

If one of the types is wrong, then change one or both so the pattern match
can succeed:

```dart
void f(String? s) {
  if (s case String _) {}
}
```

If the types are correct, then remove the pattern match:

```dart
void f(double x) {}
```
