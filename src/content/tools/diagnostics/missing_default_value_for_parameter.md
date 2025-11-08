---
title: missing_default_value_for_parameter
description: >-
  Details about the missing_default_value_for_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The parameter '{0}' can't have a value of 'null' because of its type, but the implicit default value is 'null'._

_With null safety, use the 'required' keyword, not the '@required' annotation._

## Descrição

O analisador produz este diagnóstico quando an optional parameter, whether
positional or named, has a [potentially non-nullable][] type and doesn't
specify a default value. Optional parameters that have no explicit default
value have an implicit default value of `null`. If the type of the
parameter doesn't allow the parameter to have a value of `null`, then the
implicit default value isn't valid.

## Exemplos

O código a seguir produz este diagnóstico porque `x` can't be `null`,
and no non-`null` default value is specified:

```dart
void f([int [!x!]]) {}
```

As does this:

```dart
void g({int [!x!]}) {}
```

## Correções comuns

If you want to use `null` to indicate that no value was provided, then you
need to make the type nullable:

```dart
void f([int? x]) {}
void g({int? x}) {}
```

If the parameter can't be null, then either provide a default value:

```dart
void f([int x = 1]) {}
void g({int x = 2}) {}
```

or make the parameter a required parameter:

```dart
void f(int x) {}
void g({required int x}) {}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
