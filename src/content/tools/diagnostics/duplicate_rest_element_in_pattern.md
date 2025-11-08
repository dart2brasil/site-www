---
title: duplicate_rest_element_in_pattern
description: >-
  Details about the duplicate_rest_element_in_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_At most one rest element is allowed in a list or map pattern._

## Descrição

O analisador produz este diagnóstico quando there's more than one rest
pattern in either a list or map pattern. A rest pattern will capture any
values unmatched by other subpatterns, making subsequent rest patterns
unnecessary because there's nothing left to capture.

## Exemplo

O código a seguir produz este diagnóstico porque há duas rest
patterns in the list pattern:

```dart
void f(List<int> x) {
  if (x case [0, ..., [!...!]]) {}
}
```

## Correções comuns

Remove all but one of the rest patterns:

```dart
void f(List<int> x) {
  if (x case [0, ...]) {}
}
```
