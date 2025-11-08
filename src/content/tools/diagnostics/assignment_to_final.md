---
title: assignment_to_final
description: >-
  Details about the assignment_to_final
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' can't be used as a setter because it's final._

## Descrição

O analisador produz este diagnóstico quando it finds an invocation of a
setter, but there's no setter because the field with the same name was
declared to be `final` or `const`.

## Exemplo

O código a seguir produz este diagnóstico porque `v` is final:

```dart
class C {
  final v = 0;
}

f(C c) {
  c.[!v!] = 1;
}
```

## Correções comuns

If you need to be able to set the value of the field, then remove the
modifier `final` from the field:

```dart
class C {
  int v = 0;
}

f(C c) {
  c.v = 1;
}
```
