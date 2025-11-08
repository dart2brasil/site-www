---
title: unreachable_switch_default
description: >-
  Details about the unreachable_switch_default
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This default clause is covered by the previous cases._

## Descrição

O analisador produz este diagnóstico quando a `default` clause in a
`switch` statement doesn't match anything because all of the matchable
values are matched by an earlier `case` clause.

## Exemplo

O código a seguir produz este diagnóstico porque the values `E.e1` and
`E.e2` were matched in the preceding cases:

```dart
enum E { e1, e2 }

void f(E x) {
  switch (x) {
    case E.e1:
      print('one');
    case E.e2:
      print('two');
    [!default!]:
      print('other');
  }
}
```

## Correções comuns

Remove the unnecessary `default` clause:

```dart
enum E { e1, e2 }
void f(E x) {
  switch (x) {
    case E.e1:
      print('one');
    case E.e2:
      print('two');
  }
}
```
