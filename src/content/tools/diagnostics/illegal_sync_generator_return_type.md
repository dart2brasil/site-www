---
title: illegal_sync_generator_return_type
description: >-
  Details about the illegal_sync_generator_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Functions marked 'sync*' must have a return type that is a supertype of 'Iterable<T>' for some type 'T'._

## Descrição

O analisador produz este diagnóstico quando the body of a function has the
`sync*` modifier even though the return type of the function isn't either
`Iterable` or a supertype of `Iterable`.

## Exemplo

O código a seguir produz este diagnóstico porque the body of the
function `f` has the 'sync*' modifier even though the return type `int`
isn't a supertype of `Iterable`:

```dart
[!int!] f() sync* {}
```

## Correções comuns

If the function should return an iterable, then change the return type to
be either `Iterable` or a supertype of `Iterable`:

```dart
Iterable<int> f() sync* {}
```

If the function should return a single value, then remove the `sync*`
modificador:

```dart
int f() => 0;
```
