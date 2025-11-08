---
title: for_in_of_invalid_type
description: >-
  Details about the for_in_of_invalid_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type '{0}' used in the 'for' loop must implement '{1}'._

## Descrição

O analisador produz este diagnóstico quando the expression following `in` in
a for-in loop has a type that isn't a subclass of `Iterable`.

## Exemplo

O código a seguir produz este diagnóstico porque `m` is a `Map`, and
`Map` isn't a subclass of `Iterable`:

```dart
void f(Map<String, String> m) {
  for (String s in [!m!]) {
    print(s);
  }
}
```

## Correções comuns

Replace the expression with one that produces an iterable value:

```dart
void f(Map<String, String> m) {
  for (String s in m.values) {
    print(s);
  }
}
```
