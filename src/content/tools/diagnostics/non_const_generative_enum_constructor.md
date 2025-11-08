---
ia-translate: true
title: non_const_generative_enum_constructor
description: >-
  Detalhes sobre o diagnóstico non_const_generative_enum_constructor
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Generative enum constructors must be 'const'._

## Description

O analisador produz este diagnóstico quando uma declaração enum contém um
construtor generativo que não está marcado como `const`.

## Example

O código a seguir produz este diagnóstico porque o construtor em `E`
não está marcado como `const`:

```dart
enum E {
  e;

  [!E!]();
}
```

## Common fixes

Adicione a keyword `const` antes do construtor:

```dart
enum E {
  e;

  const E();
}
```
