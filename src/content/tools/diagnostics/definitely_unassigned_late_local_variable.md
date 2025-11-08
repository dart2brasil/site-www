---
title: definitely_unassigned_late_local_variable
description: >-
  Details about the definitely_unassigned_late_local_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The late local variable '{0}' is definitely unassigned at this point._

## Descrição

O analisador produz este diagnóstico quando [definite assignment][] analysis
shows that a local variable that's marked as `late` is read before being
assigned.

## Exemplo

O código a seguir produz este diagnóstico porque `x` wasn't assigned a
value before being read:

```dart
void f(bool b) {
  late int x;
  print([!x!]);
}
```

## Correções comuns

Assign a value to the variable before reading from it:

```dart
void f(bool b) {
  late int x;
  x = b ? 1 : 0;
  print(x);
}
```

[definite assignment]: /resources/glossary#definite-assignment
