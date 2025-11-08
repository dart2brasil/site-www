---
title: extension_override_argument_not_assignable
description: >-
  Details about the extension_override_argument_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type of the argument to the extension override '{0}' isn't assignable to the extended type '{1}'._

## Descrição

O analisador produz este diagnóstico quando the argument to an extension
override isn't assignable to the type being extended by the extension.

## Exemplo

O código a seguir produz este diagnóstico porque `3` isn't a `String`:

```dart
extension E on String {
  void method() {}
}

void f() {
  E([!3!]).method();
}
```

## Correções comuns

If you're using the correct extension, then update the argument to have the
correct type:

```dart
extension E on String {
  void method() {}
}

void f() {
  E(3.toString()).method();
}
```

If there's a different extension that's valid for the type of the argument,
then either replace the name of the extension or unwrap the argument so
that the correct extension is found.
