---
title: extension_declares_constructor
description: >-
  Details about the extension_declares_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extensions can't declare constructors._

## Descrição

O analisador produz este diagnóstico quando a constructor declaration is
found in an extension. It isn't valid to define a constructor because
extensions aren't classes, and it isn't possible to create an instance of
an extension.

## Exemplo

O código a seguir produz este diagnóstico porque there is a constructor
declaration in `E`:

```dart
extension E on String {
  [!E!]() : super();
}
```

## Correções comuns

Remove the constructor or replace it with a static method.
