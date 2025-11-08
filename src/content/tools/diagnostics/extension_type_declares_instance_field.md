---
title: extension_type_declares_instance_field
description: >-
  Details about the extension_type_declares_instance_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extension types can't declare instance fields._

## Descrição

O analisador produz este diagnóstico quando there's a field declaration in
the body of an extension type declaration.

## Exemplo

O código a seguir produz este diagnóstico porque the extension type `E`
declares a field named `f`:

```dart
extension type E(int i) {
  final int [!f!] = 0;
}
```

## Correções comuns

If you don't need the field, then remove it or replace it with a getter
and/or setter:

```dart
extension type E(int i) {
  int get f => 0;
}
```

If you need the field, then convert the extension type into a class:

```dart
class E {
  final int i;

  final int f = 0;

  E(this.i);
}
```
