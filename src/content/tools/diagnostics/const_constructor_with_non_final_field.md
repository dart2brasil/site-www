---
title: const_constructor_with_non_final_field
description: >-
  Details about the const_constructor_with_non_final_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Can't define a const constructor for a class with non-final fields._

## Descrição

O analisador produz este diagnóstico quando a constructor está marcado como a
const constructor, but the constructor is defined in a class that has at
least one non-final instance field (either directly or by inheritance).

## Exemplo

O código a seguir produz este diagnóstico porque the field `x` isn't
final:

```dart
class C {
  int x;

  const [!C!](this.x);
}
```

## Correções comuns

If it's possible to mark all of the fields as final, then do so:

```dart
class C {
  final int x;

  const C(this.x);
}
```

If it isn't possible to mark all of the fields as final, then remove the
keyword `const` from the construtor:

```dart
class C {
  int x;

  C(this.x);
}
```
