---
title: illegal_async_return_type
description: >-
  Details about the illegal_async_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Functions marked 'async' must have a return type which is a supertype of 'Future'._

## Descrição

O analisador produz este diagnóstico quando the body of a function has the
`async` modifier even though the return type of the function isn't
assignable to `Future`.

## Exemplo

O código a seguir produz este diagnóstico porque the body of the
function `f` has the `async` modifier even though the return type isn't
assignable to `Future`:

```dart
[!int!] f() async {
  return 0;
}
```

## Correções comuns

If the function should be asynchronous, then change the return type to be
assignable to `Future`:

```dart
Future<int> f() async {
  return 0;
}
```

If the function should be synchronous, then remove the `async` modificador:

```dart
int f() => 0;
```
