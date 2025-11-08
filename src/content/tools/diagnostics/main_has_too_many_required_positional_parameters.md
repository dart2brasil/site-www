---
title: main_has_too_many_required_positional_parameters
description: >-
  Details about the main_has_too_many_required_positional_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The function 'main' can't have more than two required positional parameters._

## Descrição

O analisador produz este diagnóstico quando a function named `main` has more
than two required positional parameters.

## Exemplo

O código a seguir produz este diagnóstico porque the function `main` has
three required positional parameters:

```dart
void [!main!](List<String> args, int x, int y) {}
```

## Correções comuns

If the function is an entry point and the extra parameters aren't used,
then remove them:

```dart
void main(List<String> args, int x) {}
```

If the function is an entry point, but the extra parameters used are for
when the function isn't being used as an entry point, then make the extra
parameters optional:

```dart
void main(List<String> args, int x, [int y = 0]) {}
```

If the function isn't an entry point, then change the name of the function:

```dart
void f(List<String> args, int x, int y) {}
```
