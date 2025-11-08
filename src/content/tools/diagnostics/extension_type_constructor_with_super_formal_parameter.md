---
title: extension_type_constructor_with_super_formal_parameter
description: >-
  Details about the extension_type_constructor_with_super_formal_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extension type constructors can't declare super formal parameters._

## Descrição

O analisador produz este diagnóstico quando a constructor in an extension
type has a super parameter. Super parameters aren't valid because
extension types don't have a superclass.

## Exemplo

O código a seguir produz este diagnóstico porque the named constructor
`n` contains a super parameter:

```dart
extension type E(int i) {
  E.n(this.i, [!super!].foo);
}
```

## Correções comuns

If you need the parameter, replace the super parameter with a normal
parameter:

```dart
extension type E(int i) {
  E.n(this.i, String foo);
}
```

If you don't need the parameter, remove the super parameter:

```dart
extension type E(int i) {
  E.n(this.i);
}
```
