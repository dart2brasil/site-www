---
title: nullable_type_in_with_clause
description: >-
  Details about the nullable_type_in_with_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A class or mixin can't mix in a nullable type._

## Descrição

O analisador produz este diagnóstico quando a class or mixin declaration has
a `with` clause, and a mixin is followed by a `?`.

It isn't valid to specify a nullable mixin because doing so would have no
meaning; it wouldn't change either the interface or implementation being
inherited by the class containing the `with` clause.

Note, however, that it _is_ valid to use a nullable type as a type argument
to the mixin, such as `class A with B<C?> {}`.

## Exemplo

O código a seguir produz este diagnóstico porque `A?` is a nullable
type, and nullable types can't be used in a `with` clause:

```dart
mixin M {}
class C with [!M?!] {}
```

## Correções comuns

Remove the question mark from the type:

```dart
mixin M {}
class C with M {}
```
