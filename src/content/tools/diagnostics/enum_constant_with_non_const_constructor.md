---
ia-translate: true
title: enum_constant_with_non_const_constructor
description: >-
  Detalhes sobre o diagnóstico enum_constant_with_non_const_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor invocado não é um construtor 'const'._

## Descrição

O analisador produz este diagnóstico quando um valor enum está sendo criado
usando um construtor factory ou um construtor generativo que não é
marcado como sendo `const`.

## Exemplo

O código a seguir produz este diagnóstico porque o valor enum `e` está
sendo inicializado por um construtor factory:

```dart
enum E {
  [!e!]();

  factory E() => e;
}
```

## Correções comuns

Use um construtor generativo marcado como `const`:

```dart
enum E {
  e._();

  factory E() => e;

  const E._();
}
```
