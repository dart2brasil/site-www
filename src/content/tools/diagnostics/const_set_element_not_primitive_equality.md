---
title: const_set_element_not_primitive_equality
description: >-
  Details about the const_set_element_not_primitive_equality
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_(Previously known as `const_set_element_type_implements_equals`)_

_An element in a constant set can't override the '==' operator, or 'hashCode', but the type '{0}' does._

## Descrição

O analisador produz este diagnóstico quando the class of object used as an
element in a constant set literal implements either the `==` operator, the
getter `hashCode`, or both. The implementation of constant sets uses both
the `==` operator and the `hashCode` getter, so any implementation other
than the ones inherited from `Object` requires executing arbitrary code at
compile time, which isn't supported.

## Exemplo

O código a seguir produz este diagnóstico porque the constant set
contains an element whose type is `C`, and the class `C` overrides the
implementation of `==`:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

const set = {[!C()!]};
```

O código a seguir produz este diagnóstico porque the constant set
contains an element whose type is `C`, and the class `C` overrides the
implementation of `hashCode`:

```dart
class C {
  const C();

  int get hashCode => 3;
}

const map = {[!C()!]};
```

## Correções comuns

If you can remove the implementation of `==` and `hashCode` from the
class, then do so:

```dart
class C {
  const C();
}

const set = {C()};
```

If you can't remove the implementation of `==` and `hashCode` from the
class, then make the set non-constant:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

final set = {C()};
```
