---
title: illegal_async_generator_return_type
description: >-
  Details about the illegal_async_generator_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Functions marked 'async*' must have a return type that is a supertype of 'Stream<T>' for some type 'T'._

## Descrição

O analisador produz este diagnóstico quando the body of a function has the
`async*` modifier even though the return type of the function isn't either
`Stream` or a supertype of `Stream`.

## Exemplo

O código a seguir produz este diagnóstico porque the body of the
function `f` has the 'async*' modifier even though the return type `int`
isn't a supertype of `Stream`:

```dart
[!int!] f() async* {}
```

## Correções comuns

If the function should be asynchronous, then change the return type to be
either `Stream` or a supertype of `Stream`:

```dart
Stream<int> f() async* {}
```

If the function should be synchronous, then remove the `async*` modificador:

```dart
int f() => 0;
```
