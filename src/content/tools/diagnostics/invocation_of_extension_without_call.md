---
title: invocation_of_extension_without_call
description: >-
  Details about the invocation_of_extension_without_call
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The extension '{0}' doesn't define a 'call' method so the override can't be used in an invocation._

## Descrição

O analisador produz este diagnóstico quando an extension override is used to
invoke a function but the extension doesn't declare a `call` method.

## Exemplo

O código a seguir produz este diagnóstico porque the extension `E`
doesn't define a `call` method:

```dart
extension E on String {}

void f() {
  [!E('')!]();
}
```

## Correções comuns

If the extension is intended to define a `call` method, then declare it:

```dart
extension E on String {
  int call() => 0;
}

void f() {
  E('')();
}
```

If the extended type defines a `call` method, then remove the extension
override.

If the `call` method isn't defined, then rewrite the code so that it
doesn't invoke the `call` method.
