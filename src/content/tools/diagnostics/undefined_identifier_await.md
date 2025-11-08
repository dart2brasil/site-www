---
title: undefined_identifier_await
description: >-
  Details about the undefined_identifier_await
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Undefined name 'await' in function body not marked with 'async'._

## Descrição

O analisador produz este diagnóstico quando the name `await` is used in a
method or function body without being declared, and the body isn't marked
with the `async` keyword. The name `await` only introduces an await
expression in an asynchronous function.

## Exemplo

O código a seguir produz este diagnóstico porque the name `await` is
used in the body of `f` even though the body of `f` isn't marked with the
`async` keyword:

```dart
void f(p) { [!await!] p; }
```

## Correções comuns

Add the keyword `async` to the function body:

```dart
void f(p) async { await p; }
```
