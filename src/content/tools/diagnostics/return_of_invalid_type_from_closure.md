---
title: return_of_invalid_type_from_closure
description: >-
  Details about the return_of_invalid_type_from_closure
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The returned type '{0}' isn't returnable from a '{1}' function, as required by the closure's context._

## Descrição

O analisador produz este diagnóstico quando the static type of a returned
expression isn't assignable to the return type that the closure is required
to have.

## Exemplo

O código a seguir produz este diagnóstico porque `f` is defined to be a
function that returns a `String`, but the closure assigned to it returns an
`int`:

```dart
String Function(String) f = (s) => [!3!];
```

## Correções comuns

If the return type is correct, then replace the returned value with a value
of the correct type, possibly by converting the existing value:

```dart
String Function(String) f = (s) => 3.toString();
```
