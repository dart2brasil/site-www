---
title: static_access_to_instance_member
description: >-
  Details about the static_access_to_instance_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Instance member '{0}' can't be accessed using static access._

## Descrição

O analisador produz este diagnóstico quando a class name is used to access
an instance field. Instance fields don't exist on a class; they exist only
on an instance of the class.

## Exemplo

O código a seguir produz este diagnóstico porque `x` is an instance
field:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f() => C.[!b!];
```

## Correções comuns

If you intend to access a static field, then change the name of the field
to an existing static field:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f() => C.a;
```

If you intend to access the instance field, then use an instance of the
class to access the field:

```dart
class C {
  static int a = 0;

  int b = 0;
}

int f(C c) => c.b;
```
