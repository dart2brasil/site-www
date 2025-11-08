---
title: null_argument_to_non_null_type
description: >-
  Details about the null_argument_to_non_null_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' shouldn't be called with a 'null' argument for the non-nullable type argument '{1}'._

## Descrição

O analisador produz este diagnóstico quando `null` is passed to either the
constructor `Future.value` or the method `Completer.complete` when the type
argument used to create the instance was non-nullable. Even though the type
system can't express this restriction, passing in a `null` results in a
runtime exception.

## Exemplo

O código a seguir produz este diagnóstico porque `null` is being passed
to the constructor `Future.value` even though the type argument is the
non-nullable type `String`:

```dart
Future<String> f() {
  return Future.value([!null!]);
}
```

## Correções comuns

Pass in a non-null value:

```dart
Future<String> f() {
  return Future.value('');
}
```
