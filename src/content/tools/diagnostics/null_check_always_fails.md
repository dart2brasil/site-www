---
title: null_check_always_fails
description: >-
  Details about the null_check_always_fails
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This null-check will always throw an exception because the expression will always evaluate to 'null'._

## Descrição

O analisador produz este diagnóstico quando the null check operator (`!`)
is used on an expression whose value can only be `null`. In such a case
the operator always throws an exception, which likely isn't the intended
behavior.

## Exemplo

O código a seguir produz este diagnóstico porque the function `g` will
always return `null`, which means that the null check in `f` will always
throw:

```dart
void f() {
  [!g()!!];
}

Null g() => null;
```

## Correções comuns

If you intend to always throw an exception, then replace the null check
with an explicit `throw` expression to make the intent more clear:

```dart
void f() {
  g();
  throw TypeError();
}

Null g() => null;
```
