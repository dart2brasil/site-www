---
title: extension_type_constructor_with_super_invocation
description: >-
  Details about the extension_type_constructor_with_super_invocation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extension type constructors can't include super initializers._

## Descrição

O analisador produz este diagnóstico quando a constructor in an extension
type includes an invocation of a super constructor in the initializer
list. Because extension types don't have a superclass, there's no
constructor to invoke.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor `E.n`
invokes a super constructor in its initializer list:

```dart
extension type E(int i) {
  E.n() : i = 0, [!super!].n();
}
```

## Correções comuns

Remove the invocation of the super construtor:

```dart
extension type E(int i) {
  E.n() : i = 0;
}
```
