---
title: pattern_type_mismatch_in_irrefutable_context
description: >-
  Details about the pattern_type_mismatch_in_irrefutable_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The matched value of type '{0}' isn't assignable to the required type '{1}'._

## Descrição

O analisador produz este diagnóstico quando the type of the value on the
right-hand side of a pattern assignment or pattern declaration doesn't
match the type required by the pattern being used to match it.

## Exemplo

O código a seguir produz este diagnóstico porque `x` might not be a
`String` and hence might not match the object pattern:

```dart
void f(Object x) {
  var [!String(length: a)!] = x;
  print(a);
}
```

## Correções comuns

Change the code so that the type of the expression on the right-hand side
matches the type required by the pattern:

```dart
void f(String x) {
  var String(length: a) = x;
  print(a);
}
```
