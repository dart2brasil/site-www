---
title: type_check_with_null
description: >-
  Details about the type_check_with_null
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Tests for non-null should be done with '!= null'._

_Tests for null should be done with '== null'._

## Descrição

O analisador produz este diagnóstico quando there's a type check (using the
`as` operator) where the type is `Null`. There's only one value whose type
is `Null`, so the code is both more readable and more performant when it
tests for `null` explicitly.

## Exemplos

O código a seguir produz este diagnóstico porque the code is testing to
see whether the value of `s` is `null` by using a type check:

```dart
void f(String? s) {
  if ([!s is Null!]) {
    return;
  }
  print(s);
}
```

O código a seguir produz este diagnóstico porque the code is testing to
see whether the value of `s` is something other than `null` by using a type
check:

```dart
void f(String? s) {
  if ([!s is! Null!]) {
    print(s);
  }
}
```

## Correções comuns

Replace the type check with the equivalent comparison with `null`:

```dart
void f(String? s) {
  if (s == null) {
    return;
  }
  print(s);
}
```
