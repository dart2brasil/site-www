---
title: nullable_type_in_on_clause
description: >-
  Details about the nullable_type_in_on_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A mixin can't have a nullable type as a superclass constraint._

## Descrição

O analisador produz este diagnóstico quando a mixin declaration uses an `on`
clause to specify a superclass constraint, and the class that's specified
is followed by a `?`.

It isn't valid to specify a nullable superclass constraint because doing so
would have no meaning; it wouldn't change the interface being depended on
by the mixin containing the `on` clause.

Note, however, that it _is_ valid to use a nullable type as a type argument
to the superclass constraint, such as `mixin A on B<C?> {}`.


## Exemplo

O código a seguir produz este diagnóstico porque `A?` is a nullable type
and nullable types can't be used in an `on` clause:

```dart
class C {}
mixin M on [!C?!] {}
```

## Correções comuns

Remove the question mark from the type:

```dart
class C {}
mixin M on C {}
```
