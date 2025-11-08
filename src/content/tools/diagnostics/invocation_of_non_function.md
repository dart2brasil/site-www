---
title: invocation_of_non_function
description: >-
  Details about the invocation_of_non_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' isn't a function._

## Descrição

O analisador produz este diagnóstico quando it finds a function invocation,
but the name of the function being invoked is defined to be something other
than a function.

## Exemplo

O código a seguir produz este diagnóstico porque `Binary` is the name of
a function type, not a function:

```dart
typedef Binary = int Function(int, int);

int f() {
  return [!Binary!](1, 2);
}
```

## Correções comuns

Replace the name with the name of a function.
