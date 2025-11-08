---
title: non_const_generative_enum_constructor
description: >-
  Details about the non_const_generative_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Generative enum constructors must be 'const'._

## Descrição

O analisador produz este diagnóstico quando an enum declaration contains a
generative constructor that isn't marked as `const`.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor in `E`
isn't marked as being `const`:

```dart
enum E {
  e;

  [!E!]();
}
```

## Correções comuns

Add the `const` keyword before the construtor:

```dart
enum E {
  e;

  const E();
}
```
