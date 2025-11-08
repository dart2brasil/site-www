---
title: extension_override_with_cascade
description: >-
  Details about the extension_override_with_cascade
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Extension overrides have no value so they can't be used as the receiver of a cascade expression._

## Descrição

O analisador produz este diagnóstico quando an extension override is used as
the receiver of a cascade expression. The value of a cascade expression
`e..m` is the value of the receiver `e`, but extension overrides aren't
expressions and don't have a value.

## Exemplo

O código a seguir produz este diagnóstico porque `E(3)` isn't an
expression:

```dart
extension E on int {
  void m() {}
}
f() {
  [!E!](3)..m();
}
```

## Correções comuns

Use `.` rather than `..`:

```dart
extension E on int {
  void m() {}
}
f() {
  E(3).m();
}
```

If there are multiple cascaded accesses, you'll need to duplicate the
extension override for each one.
