---
title: use_of_void_result
description: >-
  Details about the use_of_void_result
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This expression has a type of 'void' so its value can't be used._

## Descrição

O analisador produz este diagnóstico quando it finds an expression whose
type is `void`, and the expression is used in a place where a value is
expected, such as before a member access or on the right-hand side of an
assignment.

## Exemplo

O código a seguir produz este diagnóstico porque `f` doesn't produce an
object on which `toString` can be invoked:

```dart
void f() {}

void g() {
  [!f()!].toString();
}
```

## Correções comuns

Either rewrite the code so that the expression has a value or rewrite the
code so that it doesn't depend on the value.
