---
title: supertype_expands_to_type_parameter
description: >-
  Details about the supertype_expands_to_type_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A type alias that expands to a type parameter can't be implemented._

_A type alias that expands to a type parameter can't be mixed in._

_A type alias that expands to a type parameter can't be used as a superclass constraint._

_A type alias that expands to a type parameter can't be used as a superclass._

## Descrição

O analisador produz este diagnóstico quando a type alias that expands to a
type parameter is used in an `extends`, `implements`, `with`, or `on`
clause.

## Exemplo

O código a seguir produz este diagnóstico porque the type alias `T`,
which expands to the type parameter `S`, is used in the `extends` clause of
the class `C`:

```dart
typedef T<S> = S;

class C extends [!T!]<Object> {}
```

## Correções comuns

Use the value of the type argument directly:

```dart
typedef T<S> = S;

class C extends Object {}
```
