---
title: extension_declares_abstract_member
description: >-
  Details about the extension_declares_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extensions can't declare abstract members._

## Descrição

O analisador produz este diagnóstico quando an abstract declaration is
declared in an extension. Extensions can declare only concrete members.

## Exemplo

O código a seguir produz este diagnóstico porque the method `a` doesn't
have a body:

```dart
extension E on String {
  int [!a!]();
}
```

## Correções comuns

Either provide an implementation for the member or remove it.
