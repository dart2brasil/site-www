---
title: initializer_for_non_existent_field
description: >-
  Details about the initializer_for_non_existent_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' isn't a field in the enclosing class._

## Descrição

O analisador produz este diagnóstico quando a constructor initializes a
field that isn't declared in the class containing the constructor.
Constructors can't initialize fields that aren't declared and fields that
are inherited from superclasses.

## Exemplo

O código a seguir produz este diagnóstico porque the initializer is
initializing `x`, but `x` isn't a field in the class:

```dart
class C {
  int? y;

  C() : [!x = 0!];
}
```

## Correções comuns

If a different field should be initialized, then change the name to the
name of the field:

```dart
class C {
  int? y;

  C() : y = 0;
}
```

If the field must be declared, then add a declaration:

```dart
class C {
  int? x;
  int? y;

  C() : x = 0;
}
```
