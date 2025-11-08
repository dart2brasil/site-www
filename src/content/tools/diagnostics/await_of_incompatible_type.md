---
title: await_of_incompatible_type
description: >-
  Details about the await_of_incompatible_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The 'await' expression can't be used for an expression with an extension type that is not a subtype of 'Future'._

## Descrição

O analisador produz este diagnóstico quando the type of the expression in
an `await` expression is an extension type, and the extension type isn't a
subclass of `Future`.

## Exemplo

O código a seguir produz este diagnóstico porque the extension type `E`
isn't a subclass of `Future`:

```dart
extension type E(int i) {}

void f(E e) async {
  [!await!] e;
}
```

## Correções comuns

If the extension type is correctly defined, then remove the `await`:

```dart
extension type E(int i) {}

void f(E e) {
  e;
}
```

If the extension type is intended to be awaitable, then add `Future` (or a
subtype of `Future`) to the `implements` clause (adding an `implements`
clause if there isn't one already), and make the representation type
match:

```dart
extension type E(Future<int> i) implements Future<int> {}

void f(E e) async {
  await e;
}
```
