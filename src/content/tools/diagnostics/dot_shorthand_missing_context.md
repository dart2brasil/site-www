---
title: dot_shorthand_missing_context
description: >-
  Details about the dot_shorthand_missing_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A dot shorthand can't be used where there is no context type._

## Descrição

O analisador produz este diagnóstico quando a dot shorthand is used where
there is no context type.

## Exemplo

O código a seguir produz este diagnóstico porque there is no context
type for the expression `.a`:

```dart
void f() {
  var e = [!.a!];
  print(e);
}

enum E {a, b}
```

## Correções comuns

If you want to use a dot shorthand, then add a context type, which in this
example means adding the explicit type `E` to the local variable:

```dart
void f() {
  E e = .a;
  print(e);
}

enum E {a, b}
```

If you don't want to add a context type, then specify the name of the
type containing the member being referenced, which in this case is `E`:

```dart
void f() {
  var e = E.a;
  print(e);
}

enum E {a, b}
```
