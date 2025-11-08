---
title: missing_enum_constant_in_switch
description: >-
  Details about the missing_enum_constant_in_switch
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Missing case clause for '{0}'._

## Descrição

O analisador produz este diagnóstico quando a `switch` statement for an enum
doesn't include an option for one of the values in the enum.

Note that `null` is always a possible value for an enum and therefore also
must be handled.

## Exemplo

O código a seguir produz este diagnóstico porque the enum value `e2`
isn't handled:

```dart
enum E { e1, e2 }

void f(E e) {
  [!switch (e)!] {
    case E.e1:
      break;
  }
}
```

## Correções comuns

If there's special handling for the missing values, then add a `case`
clause for each of the missing values:

```dart
enum E { e1, e2 }

void f(E e) {
  switch (e) {
    case E.e1:
      break;
    case E.e2:
      break;
  }
}
```

If the missing values should be handled the same way, then add a `default`
clause:

```dart
enum E { e1, e2 }

void f(E e) {
  switch (e) {
    case E.e1:
      break;
    default:
      break;
  }
}
```
