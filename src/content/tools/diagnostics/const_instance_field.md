---
title: const_instance_field
description: >-
  Details about the const_instance_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Only static fields can be declared as const._

## Descrição

O analisador produz este diagnóstico quando an instance field está marcado como
being const.

## Exemplo

O código a seguir produz este diagnóstico porque `f` is an instance
field:

```dart
class C {
  [!const!] int f = 3;
}
```

## Correções comuns

If the field needs to be an instance field, then remove the keyword
`const`, or replace it with `final`:

```dart
class C {
  final int f = 3;
}
```

If the field really should be a const field, then make it a static field:

```dart
class C {
  static const int f = 3;
}
```
