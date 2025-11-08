---
title: assignment_to_final_no_setter
description: >-
  Details about the assignment_to_final_no_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_There isn't a setter named '{0}' in class '{1}'._

## Descrição

O analisador produz este diagnóstico quando a reference to a setter is
found; there is no setter defined for the type; but there is a getter
defined with the same name.

## Exemplo

O código a seguir produz este diagnóstico porque there is no setter
named `x` in `C`, but there is a getter named `x`:

```dart
class C {
  int get x => 0;
  set y(int p) {}
}

void f(C c) {
  c.[!x!] = 1;
}
```

## Correções comuns

If you want to invoke an existing setter, then correct the name:

```dart
class C {
  int get x => 0;
  set y(int p) {}
}

void f(C c) {
  c.y = 1;
}
```

If you want to invoke the setter but it just doesn't exist yet, then
declare it:

```dart
class C {
  int get x => 0;
  set x(int p) {}
  set y(int p) {}
}

void f(C c) {
  c.x = 1;
}
```
