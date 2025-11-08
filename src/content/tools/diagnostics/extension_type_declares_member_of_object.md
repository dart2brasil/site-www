---
title: extension_type_declares_member_of_object
description: >-
  Details about the extension_type_declares_member_of_object
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extension types can't declare members with the same name as a member declared by 'Object'._

## Descrição

O analisador produz este diagnóstico quando the body of an extension type
declaration contains a member with the same name as one of the members
declared by `Object`.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `Object`
already defines a member named `hashCode`:

```dart
extension type E(int i) {
  int get [!hashCode!] => 0;
}
```

## Correções comuns

If you need a member with the implemented semantics, then rename the
member:

```dart
extension type E(int i) {
  int get myHashCode => 0;
}
```

If you don't need a member with the implemented semantics, then remove the
member:

```dart
extension type E(int i) {}
```
