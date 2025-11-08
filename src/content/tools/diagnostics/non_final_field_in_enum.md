---
title: non_final_field_in_enum
description: >-
  Details about the non_final_field_in_enum
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Enums can only declare final fields._

## Descrição

O analisador produz este diagnóstico quando an instance field in an enum
isn't marked as `final`.

## Exemplo

O código a seguir produz este diagnóstico porque the field `f` isn't a
final field:

```dart
enum E {
  c;

  int [!f!] = 0;
}
```

## Correções comuns

If the field must be defined for the enum, then mark the field as being
`final`:

```dart
enum E {
  c;

  final int f = 0;
}
```

If the field can be removed, then remove it:

```dart
enum E {
  c
}
```
