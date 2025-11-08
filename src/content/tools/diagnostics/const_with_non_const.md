---
title: const_with_non_const
description: >-
  Details about the const_with_non_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The constructor being called isn't a const constructor._

## Descrição

O analisador produz este diagnóstico quando the keyword `const` is used to
invoke a constructor that isn't marked with `const`.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor in `A`
isn't a const construtor:

```dart
class A {
  A();
}

A f() => [!const!] A();
```

## Correções comuns

If it's desirable and possible to make the class a constant class (by
making all of the fields of the class, including inherited fields, final),
then add the keyword `const` to the construtor:

```dart
class A {
  const A();
}

A f() => const A();
```

Otherwise, remove the keyword `const`:

```dart
class A {
  A();
}

A f() => A();
```
