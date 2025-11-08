---
title: unused_catch_stack
description: >-
  Details about the unused_catch_stack
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The stack trace variable '{0}' isn't used and can be removed._

## Descrição

O analisador produz este diagnóstico quando the stack trace parameter in a
`catch` clause isn't referenced within the body of the `catch` block.

## Exemplo

O código a seguir produz este diagnóstico porque `stackTrace` isn't
referenced:

```dart
void f() {
  try {
    // ...
  } catch (exception, [!stackTrace!]) {
    // ...
  }
}
```

## Correções comuns

If you need to reference the stack trace parameter, then add a reference to
it. Otherwise, remove it:

```dart
void f() {
  try {
    // ...
  } catch (exception) {
    // ...
  }
}
```
