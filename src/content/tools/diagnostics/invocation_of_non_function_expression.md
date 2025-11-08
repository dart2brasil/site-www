---
title: invocation_of_non_function_expression
description: >-
  Details about the invocation_of_non_function_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The expression doesn't evaluate to a function, so it can't be invoked._

## Descrição

O analisador produz este diagnóstico quando a function invocation is found,
but the name being referenced isn't the name of a function, or when the
expression computing the function doesn't compute a function.

## Exemplos

O código a seguir produz este diagnóstico porque `x` isn't a function:

```dart
int x = 0;

int f() => x;

var y = [!x!]();
```

O código a seguir produz este diagnóstico porque `f()` doesn't return a
function:

```dart
int x = 0;

int f() => x;

var y = [!f()!]();
```

## Correções comuns

If you need to invoke a function, then replace the code before the argument
list with the name of a function or with an expression that computes a
function:

```dart
int x = 0;

int f() => x;

var y = f();
```
