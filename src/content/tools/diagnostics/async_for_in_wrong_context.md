---
title: async_for_in_wrong_context
description: >-
  Details about the async_for_in_wrong_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The async for-in loop can only be used in an async function._

## Descrição

O analisador produz este diagnóstico quando an async for-in loop is found in
a function or method whose body isn't marked as being either `async` or
`async*`.

## Exemplo

O código a seguir produz este diagnóstico porque the body of `f` isn't
marked as being either `async` or `async*`, but `f` contains an async
for-in loop:

```dart
void f(list) {
  [!await!] for (var e in list) {
    print(e);
  }
}
```

## Correções comuns

If the function should return a `Future`, then mark the body with `async`:

```dart
Future<void> f(list) async {
  await for (var e in list) {
    print(e);
  }
}
```

If the function should return a `Stream` of values, then mark the body with
`async*`:

```dart
Stream<void> f(list) async* {
  await for (var e in list) {
    print(e);
  }
}
```

If the function should be synchronous, then remove the `await` before the
loop:

```dart
void f(list) {
  for (var e in list) {
    print(e);
  }
}
```
