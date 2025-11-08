---
title: invalid_factory_name_not_a_class
description: >-
  Details about the invalid_factory_name_not_a_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name of a factory constructor must be the same as the name of the immediately enclosing class._

## Descrição

O analisador produz este diagnóstico quando the name of a factory
constructor isn't the same as the name of the surrounding class.

## Exemplo

O código a seguir produz este diagnóstico porque the name of the factory
constructor (`A`) isn't the same as the surrounding class (`C`):

```dart
class A {}

class C {
  factory [!A!]() => throw 0;
}
```

## Correções comuns

If the factory returns an instance of the surrounding class, and you
intend it to be an unnamed factory constructor, then rename the factory:

```dart
class A {}

class C {
  factory C() => throw 0;
}
```

If the factory returns an instance of the surrounding class, and you
intend it to be a named factory constructor, then prefix the name of the
factory constructor with the name of the surrounding class:

```dart
class A {}

class C {
  factory C.a() => throw 0;
}
```

If the factory returns an instance of a different class, then move the
factory to that class:

```dart
class A {
  factory A() => throw 0;
}

class C {}
```

If the factory returns an instance of a different class, but you can't
modify that class or don't want to move the factory, then convert it to be
a static method:

```dart
class A {}

class C {
  static A a() => throw 0;
}
```
