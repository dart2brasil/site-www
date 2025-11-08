---
title: enum_constant_with_non_const_constructor
description: >-
  Details about the enum_constant_with_non_const_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The invoked constructor isn't a 'const' constructor._

## Descrição

O analisador produz este diagnóstico quando an enum value is being created
using either a factory constructor or a generative constructor that isn't
marked as being `const`.

## Exemplo

O código a seguir produz este diagnóstico porque the enum value `e` is
being initialized by a factory construtor:

```dart
enum E {
  [!e!]();

  factory E() => e;
}
```

## Correções comuns

Use a generative constructor marked as `const`:

```dart
enum E {
  e._();

  factory E() => e;

  const E._();
}
```
