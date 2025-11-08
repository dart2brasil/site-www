---
title: invalid_assignment
description: >-
  Details about the invalid_assignment
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A value of type '{0}' can't be assigned to a variable of type '{1}'._

## Descrição

O analisador produz este diagnóstico quando the static type of an expression
that is assigned to a variable isn't assignable to the type of the
variable.

## Exemplo

O código a seguir produz este diagnóstico porque the type of the
initializer (`int`) isn't assignable to the type of the variable
(`String`):

```dart
int i = 0;
String s = [!i!];
```

## Correções comuns

If the value being assigned is always assignable at runtime, even though
the static types don't reflect that, then add an explicit cast.

Otherwise, change the value being assigned so that it has the expected
type. In the previous example, this might look like:

```dart
int i = 0;
String s = i.toString();
```

If you can't change the value, then change the type of the variable to be
compatible with the type of the value being assigned:

```dart
int i = 0;
int s = i;
```
