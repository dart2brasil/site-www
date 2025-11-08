---
title: default_value_on_required_parameter
description: >-
  Details about the default_value_on_required_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Required named parameters can't have a default value._

## Descrição

O analisador produz este diagnóstico quando a named parameter has both the
`required` modifier and a default value. If the parameter is required, then
a value for the parameter is always provided at the call sites, so the
default value can never be used.

## Exemplo

The following code generates this diagnostic:

```dart
void log({required String [!message!] = 'no message'}) {}
```

## Correções comuns

If the parameter is really required, then remove the default value:

```dart
void log({required String message}) {}
```

If the parameter isn't always required, then remove the `required`
modificador:

```dart
void log({String message = 'no message'}) {}
```
