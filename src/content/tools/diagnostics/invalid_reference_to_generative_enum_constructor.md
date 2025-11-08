---
title: invalid_reference_to_generative_enum_constructor
description: >-
  Details about the invalid_reference_to_generative_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Generative enum constructors can only be used to create an enum constant._

_Generative enum constructors can't be torn off._

## Descrição

O analisador produz este diagnóstico quando a generative constructor
defined on an enum is used anywhere other than to create one of the enum
constants or as the target of a redirection from another constructor in
the same enum.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor for
`E` is being used to create an instance in the function `f`:

```dart
enum E {
  a(0);

  const E(int x);
}

E f() => const [!E!](2);
```

## Correções comuns

If there's an enum value with the same value, or if you add such a
constant, then reference the constant directly:

```dart
enum E {
  a(0), b(2);

  const E(int x);
}

E f() => E.b;
```

If you need to use a constructor invocation, then use a factory
constructor:

```dart
enum E {
  a(0);

  const E(int x);

  factory E.c(int x) => a;
}

E f() => E.c(2);
```
