---
title: assert_in_redirecting_constructor
description: >-
  Details about the assert_in_redirecting_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A redirecting constructor can't have an 'assert' initializer._

## Descrição

O analisador produz este diagnóstico quando a redirecting constructor (a
constructor that redirects to another constructor in the same class) has an
assert in the initializer list.

## Exemplo

O código a seguir produz este diagnóstico porque the unnamed constructor
is a redirecting constructor and also has an assert in the initializer
list:

```dart
class C {
  C(int x) : [!assert(x > 0)!], this.name();
  C.name() {}
}
```

## Correções comuns

If the assert isn't needed, then remove it:

```dart
class C {
  C(int x) : this.name();
  C.name() {}
}
```

If the assert is needed, then convert the constructor into a factory
constructor:

```dart
class C {
  factory C(int x) {
    assert(x > 0);
    return C.name();
  }
  C.name() {}
}
```
