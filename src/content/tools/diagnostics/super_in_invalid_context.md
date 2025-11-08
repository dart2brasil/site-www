---
title: super_in_invalid_context
description: >-
  Details about the super_in_invalid_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Invalid context for 'super' invocation._

## Descrição

O analisador produz este diagnóstico quando the keyword `super` is used
outside of an instance method.

## Exemplo

O código a seguir produz este diagnóstico porque `super` is used in a
top-level function:

```dart
void f() {
  [!super!].f();
}
```

## Correções comuns

Rewrite the code to not use `super`.
