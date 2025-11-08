---
title: non_exhaustive_switch_expression
description: >-
  Details about the non_exhaustive_switch_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type '{0}' isn't exhaustively matched by the switch cases since it doesn't match the pattern '{1}'._

## Descrição

O analisador produz este diagnóstico quando a `switch` expression is
missing a case for one or more of the possible values that could flow
through it.

## Exemplo

O código a seguir produz este diagnóstico porque the switch expression
doesn't have a case for the value `E.three`:

```dart
enum E { one, two, three }

String f(E e) => [!switch!] (e) {
    E.one => 'one',
    E.two => 'two',
  };
```

## Correções comuns

If the missing values are distinctly meaningful to the switch expression,
then add a case for each of the values missing a match:

```dart
enum E { one, two, three }

String f(E e) => switch (e) {
    E.one => 'one',
    E.two => 'two',
    E.three => 'three',
  };
```

If the missing values don't need to be matched, then add a wildcard
pattern that returns a simple default:

```dart
enum E { one, two, three }

String f(E e) => switch (e) {
    E.one => 'one',
    E.two => 'two',
    _ => 'unknown',
  };
```

Be aware that a wildcard pattern will handle any values added to the type
in the future. You will lose the ability to have the compiler warn you if
the `switch` needs to be updated to account for newly added types.
