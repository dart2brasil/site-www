---
title: not_initialized_non_nullable_variable
description: >-
  Details about the not_initialized_non_nullable_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The non-nullable variable '{0}' must be initialized._

## Descrição

O analisador produz este diagnóstico quando a static field or top-level
variable has a type that's non-nullable and não tem uma initializer.
Fields and variables that don't have an initializer are normally
initialized to `null`, but the type of the field or variable doesn't allow
it to be set to `null`, so an explicit initializer must be provided.

## Exemplos

O código a seguir produz este diagnóstico porque the field `f` can't be
initialized to `null`:

```dart
class C {
  static int [!f!];
}
```

Similarly, the following code produces this diagnostic because the
top-level variable `v` can't be initialized to `null`:

```dart
int [!v!];
```

## Correções comuns

If the field or variable can't be initialized to `null`, then add an
initializer that sets it to a non-null value:

```dart
class C {
  static int f = 0;
}
```

If the field or variable should be initialized to `null`, then change the
type to be nullable:

```dart
int? v;
```

If the field or variable can't be initialized in the declaration but will
always be initialized before it's referenced, then mark it as being `late`:

```dart
class C {
  static late int f;
}
```
